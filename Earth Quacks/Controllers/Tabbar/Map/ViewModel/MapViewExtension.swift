//
//  MapViewExtension.swift
//  Earth Quacks
//
//  Created by Shoaib on 03/04/2023.
//

import Foundation
import MapKit
import Amplitude
import MapKit

//MARK: - Filter extension

enum MapType: Int {
    case standard = 0
    case satellite = 1
    case hybrid = 2
}

extension MapViewController {
    
    //MARK: - Timer
    
    @objc func update() {
        
        if Int(self.slider.value) < Int(self.slider.maximumValue) {
            self.sliderValue(self.slider)
            self.slider.value = self.slider.value + 1
        }
        else {
            self.playPauseBtn.isSelected = false
            self.slider.value = 0
            self.timer?.invalidate()
        }
    }
    
    //MARK: -  Label setup
    
    func labelsSetup(startingDate:String = Global.shared.userConfig.defaultStartingDate, endingDate:String = Global.shared.userConfig.defaultEndingDate,magValue:Double = Global.shared.userConfig.defaultMag) {
        self.days = self.findDays(dateString1: startingDate, dateString2: endingDate)
        self.slider.minimumValue = 0
        self.slider.maximumValue = Float(self.days)
        self.allBtn.isSelected = false
        self.allBtn.backgroundColor = .clear
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constant.defaultDateFormatter
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = Constant.requireDateFormatter
        if let convertedStartDate = dateFormatter.date(from: startingDate), let convertedEndDate = dateFormatter.date(from: endingDate){
            let start = dateFormatterPrint.string(from: convertedStartDate)
            let end = dateFormatterPrint.string(from: convertedEndDate)
            self.dateBtn.setTitle("\(start) - \(end)", for: .normal)
            self.magBtn.setTitle("Magnitude \(magValue)+", for: .normal)
        } else {
            print("There was an error decoding the string")
        }
        Global.shared.userConfig.defaultStartingDate = startingDate
        Global.shared.userConfig.defaultEndingDate = endingDate
        Global.shared.userConfig.defaultMag = magValue
    }
    
    func settingUpLocation() {
        let location = CLLocation(latitude: Global.shared.userConfig.lat, longitude: Global.shared.userConfig.long)
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
    }
    
    func layerFilter() {
        Amplitude.instance().logEvent("Layers")
        let alert = UIAlertController(title: "Select Map Type", message: nil, preferredStyle: .actionSheet)
        
        let standardAction = UIAlertAction(title: "Standard", style: .default) { action in
            self.setMapType(.standard)
        }
        alert.addAction(standardAction)
        
        let satelliteAction = UIAlertAction(title: "Satellite", style: .default) { action in
            self.setMapType(.satellite)
        }
        alert.addAction(satelliteAction)
        
        let hybridAction = UIAlertAction(title: "Hybrid", style: .default) { action in
            self.setMapType(.hybrid)
        }
        alert.addAction(hybridAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func settingUpFilter() {
        self.allBtn.backgroundColor = .clear
        if let data = self.viewModel?.map.sliderFilter {
            self.setupViewForMap(isFromSlider: true,dataArray: data)
        }
    }
    
    func settingUpAll() {
        self.allBtn.backgroundColor = .black
        if let data = self.viewModel?.map.earthQuackOnlineData?.content?.earthquakes {
            self.settingUpOnlineAnnotations(annotation: data)
        }
    }
    
    func settingUpByDate(startDate:String,endDate:String) {
        Amplitude.instance().logEvent("\(startDate) \(endDate)")
        self.days = self.findDays(dateString1: startDate, dateString2: endDate)
        print(self.days)
        self.playPauseBtn.isEnabled = true
        self.playPauseBtn.alpha = 1
        self.slider.isEnabled = true
        self.slider.alpha = 1
        self.slider.value = 0
        self.slider.minimumValue = 0
        self.slider.maximumValue = Float(self.days)
        self.labelsSetup(startingDate: "\(startDate)",endingDate: "\(endDate)")
        self.viewModel?.getOnlineEarthQuack(dateFrom: startDate,dateTo:endDate,magnitudeFrom: Global.shared.userConfig.defaultMag,completion: { _ in
            self.setupViewForMap()
        })
        self.setupViewForMap()
    }
    
    func settingUpByMag(magValue:Double) {
        self.labelsSetup(magValue: magValue)
        Amplitude.instance().logEvent("\(magValue)")
        Global.shared.userConfig.defaultMag = magValue
        self.viewModel?.getOnlineEarthQuack(dateFrom: Global.shared.userConfig.defaultStartingDate,dateTo: Global.shared.userConfig.defaultEndingDate,magnitudeFrom: magValue,completion: { _ in
            self.setupViewForMap()
        })
    }
    
    func setupViewForMap(isFromSlider:Bool = false,dataArray:[EarthquakesData] = []) {
        if isFromSlider {
            self.settingUpOnlineAnnotations(annotation: dataArray)
        }
        else {
            ShareData.shareInfo.userConfig = Global.shared.userConfig
            if let data = self.viewModel?.map.earthQuackOnlineData?.content?.earthquakes {
                self.settingUpOnlineAnnotations(annotation: data)
            }
        }
        
    }
    
    func findDays(dateString1:String,dateString2:String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date1 = dateFormatter.date(from: dateString1),
              let date2 = dateFormatter.date(from: dateString2) else {
            fatalError("One or both of the date strings is invalid")
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        self.datesSelecteed.removeAll()
        var currentDate = date1
        while currentDate <= date2 {
            let dateString = dateFormatter.string(from: currentDate)
            self.datesSelecteed.append(dateString)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        // Print the array of dates
        print(self.datesSelecteed)
        
        if let days = components.day {
            print("The number of days between the two dates is: \(days)")
            return days
        } else {
            print("Error: Could not calculate the number of days")
            return 0
        }
        
    }
    
    //MARK: - Making annotations
    
    func settingUpOnlineAnnotations(annotation:[EarthquakesData]) {
        self.removeAllAnnotations()
        self.viewModel?.map.filterAnnotations.removeAll()
        
        mapView.register(UserClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(UserClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        for i in annotation {
            let coordinate = CLLocationCoordinate2D(latitude: i.latitude ?? 0.0, longitude: i.longitude ?? 0.0)
            let customAnnotation = CustomAnnotation(coordinate: coordinate, title: i.title, subtitle: "Depth \(i.depth ?? 0.0)mi", label: String(format: "%.1f", i.mag ?? 0.0))
            self.viewModel?.map.filterAnnotations.append(customAnnotation)
        }
        print(self.viewModel?.map.filterAnnotations.count ?? 0)
        
        DispatchQueue.main.async {
            if let annotations = self.viewModel?.map.filterAnnotations {
                self.mapView.addAnnotations(annotations)
                let location = CLLocation(latitude: annotations.first?.coordinate.latitude ?? 0.0, longitude: annotations.first?.coordinate.longitude ?? 0.0)
                let region = MKCoordinateRegion(center: location.coordinate , span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
                self.mapView.setRegion(region, animated: true)
            }
        }
        
    }
    
    //MARK: - Removing annotations
    
    func removeAllAnnotations() {
        let annotations = self.mapView.annotations.filter {
            $0 !== self.mapView.userLocation
        }
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(annotations)
            
        }
    }
    
}

//MARK: - Mapview Extentions

extension MapViewController: MKMapViewDelegate {
    
    func setMapType(_ mapType: MapType) {
        switch mapType {
        case .standard:
            mapView.mapType = .standard
        case .satellite:
            mapView.mapType = .satellite
        case .hybrid:
            mapView.mapType = .hybrid
        }
    }
}
