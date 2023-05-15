//
//  ListDetailViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 29/04/2023.
//

import UIKit
import MapKit
import CoreLocation

class ListDetailViewController: BaseViewController {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Detail OutLet
    
    @IBOutlet weak var gpsLbl: UILabel!
    @IBOutlet weak var timeDetailLbl: UILabel!
    @IBOutlet weak var depthLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var magLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    //MARK: - Variables

    var data : EarthquakesData?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    
    //MARK: - IBAction
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func layersBtn(_ sender: Any) {
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
    //MARK: -  Functions
    func setup() {
        
        self.mapView.delegate = self
        if let data {
            print(data)
            
            //MARK: - Setup Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: data.created ?? "")
            if let date {
                dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
                let newDateString = dateFormatter.string(from: date)
                self.timeLbl.text = newDateString
                print(newDateString)
            }
            else {
                let datee = data.created?.split(separator: " ").first
                let time = data.created?.split(separator: " ").last
                self.timeLbl.text = "\(datee ?? "Unknown Date ")" + " \(time ?? " Unknown Time")"
            }
            self.timeDetailLbl.text = (data.created ?? "") + " " + (TimeZone.current.abbreviation() ?? "UTC")
            
            //MARK: - Calculate Distance
            
//            let coordinate1 = CLLocationCoordinate2D(latitude: Global.shared.userConfig.lat, longitude: Global.shared.userConfig.long)
//            let coordinate2 = CLLocationCoordinate2D(latitude: data.latitude ?? 0.0, longitude: data.longitude ?? 0.0)
//            let distance = distanceBetweenCoordinates(coordinate1: coordinate1, coordinate2: coordinate2)
            self.distanceLbl.text = "  \(String(format: "%.2f mi", data.distance ?? "0.0"))"
            
            
            //MARK: - Other Labels
            self.magLbl.text = String(format: "%.1f", data.mag ?? 0.0)
            self.cityName.text = "\(data.title ?? "Unknown")"
            self.locationLbl.text = "\(data.city ?? data.title ?? "Unknown")"
            self.depthLbl.text = String(format: "%.1f mi", data.depth ?? 0.0)
            self.gpsLbl.text = "\(data.latitude ?? 0.0)°N " +  " \(data.longitude ?? 0.0)°W"
            self.settingUpOnlineAnnotations(annotation: data)
        }
    }
    
    //MARK: - Making annotations
    
    func settingUpOnlineAnnotations(annotation:EarthquakesData) {
        self.removeAllAnnotations()
        let coordinate = CLLocationCoordinate2D(latitude: annotation.latitude ?? 0.0, longitude: annotation.longitude ?? 0.0)
        let customAnnotation = CustomAnnotation(coordinate: coordinate, title: annotation.city, subtitle: "\(annotation.distance ?? 0.0)mi", label: String(format: "%.1f", annotation.mag ?? 0.0))
        DispatchQueue.main.async {
            let zoomLevel = 0.02
            let region = MKCoordinateRegion(center: customAnnotation.coordinate, latitudinalMeters: zoomLevel, longitudinalMeters: zoomLevel)
            self.mapView.setRegion(region, animated: true)
            self.mapView.showAnnotations([customAnnotation], animated: true)
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

extension ListDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let customAnnotation = annotation as? CustomAnnotation {
            let annotationView = CustomAnnotationView(annotation: customAnnotation, reuseIdentifier: "CustomAnnotationView")
            return annotationView
        }
        return nil
    }
    
//    func distanceBetweenCoordinates(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
//        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
//        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
//        return location1.distance(from: location2) / 1000 * 0.621371 // Convert to miles
//    }
    
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
