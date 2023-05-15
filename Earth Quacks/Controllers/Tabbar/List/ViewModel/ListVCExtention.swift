//
//  ListVCExtention.swift
//  Earth Quacks
//
//  Created by Shoaib on 28/04/2023.
//

import Foundation
import UIKit
import Amplitude
import CoreLocation

enum SortOption {
    case byMagnitude
    case byDate
    case byDistance
}

//MARK: - Labels

extension ListViewController {
    func labelsSetup(startingDate:String = Global.shared.userConfig.defaultStartingDate, endingDate:String = Global.shared.userConfig.defaultEndingDate,magValue:Double = Global.shared.userConfig.defaultMag) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constant.defaultDateFormatter
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = Constant.requireDateFormatter
        if let convertedStartDate = dateFormatter.date(from: startingDate), let convertedEndDate = dateFormatter.date(from: endingDate){
            let start = dateFormatterPrint.string(from: convertedStartDate)
            let end = dateFormatterPrint.string(from: convertedEndDate)
            DispatchQueue.main.async {
                self.dateBtn.setTitle("\(start) - \(end)", for: .normal)
                self.magBtn.setTitle("Magnitude \(magValue)+", for: .normal)
            }
            
        } else {
            print("There was an error decoding the string")
        }
        let miles = distanceMiles[Global.shared.userConfig.alertDistance]
        if miles == 1000 {
            self.mileBtn.setTitle("\(miles)+mi", for: .normal)
        }
        else {
            self.mileBtn.setTitle("\(miles)mi", for: .normal)
        }
        
        Global.shared.userConfig.defaultStartingDate = startingDate
        Global.shared.userConfig.defaultEndingDate = endingDate
        Global.shared.userConfig.defaultMag = magValue
    }
    
    func settingUpByDate(startDate:String,endDate:String) {
        self.labelsSetup(startingDate: "\(startDate)",endingDate: "\(endDate)")
        self.viewModel?.getOnlineEarthQuack(dateFrom: startDate,dateTo:endDate,magnitudeFrom: Global.shared.userConfig.defaultMag,completion: { _ in
            self.setupViewModel(pageSize: 50)
        })
    }
    
}

//MARK: - Search
extension ListViewController : UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.viewModel?.searching = false
        }
        else {
            Amplitude.instance().logEvent(searchText)
            if let data = self.viewModel?.data {
                self.viewModel?.searching = true
                self.viewModel?.filterData = data.filter { item in
                    print(item)
                    if let title = item.title?.lowercased(){
                        if title.contains(searchText.lowercased()) {
                            return true
                        }
                        return false
                    }
                    
                    return false
                }
            }
            else {
                self.viewModel?.searching = false
            }
            
        }
        self.tableView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func setupDistance(lat:Double,long:Double) -> Double {
        let coordinate1 = CLLocationCoordinate2D(latitude: Global.shared.userConfig.lat, longitude: Global.shared.userConfig.long)
        let coordinate2 = CLLocationCoordinate2D(latitude: lat, longitude: lat)
        let distance = distanceBetweenCoordinates(coordinate1: coordinate1, coordinate2: coordinate2)
        return distance
    }
    
    func distanceBetweenCoordinates(coordinate1: CLLocationCoordinate2D, coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        return location1.distance(from: location2) / 1000 * 0.621371 // Convert to miles
    }
    func noDaataCheck() {
        if self.viewModel?.searching ?? false {
            if self.viewModel?.filterData?.count ?? 0 == 0 {
                self.noDataView.isHidden = false
            }
            else {
                self.noDataView.isHidden = true
            }
        }
        else {
            if self.viewModel?.data?.count ?? 0 == 0 {
                self.noDataView.isHidden = false
            }
            else {
                self.noDataView.isHidden = true
            }
        }
    }
}

//MARK: - TableView

extension ListViewController : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.noDaataCheck()
        return self.viewModel?.searching ?? false ? self.viewModel?.filterData?.count ?? 0 : self.viewModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(ListTableViewCell.self, indexPath: indexPath)
        let data = self.viewModel?.searching ?? false ? self.viewModel?.filterData?[indexPath.row] : self.viewModel?.data?[indexPath.row]
        cell.config(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let data = self.viewModel?.searching ?? false ? self.viewModel?.filterData?[indexPath.row] : self.viewModel?.data?[indexPath.row]
        let vc = ListDetailViewController(nibName: "ListDetailViewController", bundle: nil)
        vc.data = data
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) && !isLoadingList) {
                if self.viewModel?.data?.count ?? 0 < (self.viewModel?.totalData?.content?.pagination?.total ?? 0) - 10 {
                self.isLoadingList = true
                self.viewModel?.count += 50
                self.setupViewModel(pageSize: self.viewModel?.count ?? 50)
            }
        }
    }
}

//MARK: -  API call
extension ListViewController {
    func setupViewModel(distance:Double=99999999999999.0,pageSize : Int) {
        Global.shared.userConfig.miles = distance
        ShareData.shareInfo.userConfig = Global.shared.userConfig
        self.viewModel?.getOnlineEarthQuack(distance: distance, dateFrom: Global.shared.userConfig.defaultStartingDate,dateTo: Global.shared.userConfig.defaultEndingDate,magnitudeFrom: Global.shared.userConfig.defaultMag,pageSize: pageSize,completion: { data in
            self.isLoadingList = false
            if let data {
                self.viewModel?.totalData = data
                self.viewModel?.data = data.content?.earthquakes
                if let data = data.content?.earthquakes {
                    DispatchQueue.main.async {
                        for (i,index) in data.enumerated() {
                            self.viewModel?.data?[i].distance = self.setupDistance(lat: index.latitude ?? 0.0, long: index.longitude ?? 0.0)
                        }
                        self.tableView.reloadData()
                    }
                }


            }
            else {
                AppUtility.showInfoMessage(message: "Internet problem")
            }
        })
    }
    
    func sortItems(by sortOption: SortOption) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        switch sortOption {
        case .byMagnitude:
            if var data = self.viewModel?.searching ?? false ? self.viewModel?.filterData : self.viewModel?.data {
                self.viewModel?.searching ?? false ? data.sort(by: { $0.mag ?? 0.0 > $1.mag ?? 0.0 }) : data.sort(by: { $0.mag ?? 0.0 > $1.mag ?? 0.0 })
                if self.viewModel?.searching ?? false {
                    self.viewModel?.filterData = data
                }
                else {
                    self.viewModel?.data = data
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }

        case .byDate:
            if var data = self.viewModel?.searching ?? false ? self.viewModel?.filterData : self.viewModel?.data {
                self.viewModel?.searching ?? false ? data.sort(by: { dateFormatter.date(from: $0.created ?? "")! < dateFormatter.date(from: $1.created ?? "")! }) : data.sort(by: { dateFormatter.date(from: $0.created ?? "")! < dateFormatter.date(from: $1.created ?? "")! })
                if self.viewModel?.searching ?? false {
                    self.viewModel?.filterData = data
                }
                else {
                    self.viewModel?.data = data
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        case .byDistance:
            
            if var data = self.viewModel?.searching ?? false ? self.viewModel?.filterData : self.viewModel?.data {
                self.viewModel?.searching ?? false ? data.sort(by: { $0.distance ?? 0.0 < $1.distance ?? 0.0 }) : data.sort(by: { $0.distance ?? 0.0 < $1.distance ?? 0.0 })
                if self.viewModel?.searching ?? false {
                    self.viewModel?.filterData = data
                }
                else {
                    self.viewModel?.data = data
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
