//
//  MapViewModel.swift
//  Earth Quacks
//
//  Created by Shoaib on 03/04/2023.
//

import Foundation
import MapKit

struct MapData {
    
    //MARK: - Online
    var earthQuackOnlineData : EarthQuackModel?
    var sliderFilter : [EarthquakesData]?
    var filterAnnotations = [MKAnnotation]()
    let locationManager = CLLocationManager()
    var isLastFilterMag = false
}

class MapViewModel {
    var map: MapData
    var pageSize = 10
    var callback : ((Bool) -> Void)?
    init(map: MapData = MapData()) {
        self.map = map
    }
    
    func getOnlineEarthQuack(dateFrom:String = "2005-03-01",dateTo:String = "2023-03-23",magnitudeFrom:Double = 5.0,magnitudeTo:Double = 10.0,depthFrom:Double = 0.0,depthTo:Double = 1000.0,page:Int = 1,pageSize:Int = 10,topRightLat:Double = 0.0,topRightLong:Double = 0.0,topLeftLat:Double = 0.0,topLeftLong:Double = 0.0,bottomRightLat:Double = 0.0,bottomRightLong:Double = 0.0,bottomLeftLat:Double = 0.0,bottomLeftLong:Double = 0.0,completion: @escaping (EarthQuackModel?) -> Void) {
        ApiClient.shared.getEarthQuacks(dateFrom: dateFrom, dateTo: dateTo, magnitudeFrom: magnitudeFrom, magnitudeTo: magnitudeTo, depthFrom: depthFrom, depthTo: depthTo, page: page, pageSize: pageSize,fromMap: true,topRightLat: topRightLat,topRightLong: topRightLong, topLeftLat: topLeftLat,topLeftLong: topLeftLong,bottomRightLat: bottomRightLat,bottomRightLong: bottomRightLong,bottomLeftLat: bottomLeftLat,bottomLeftLong: bottomLeftLong) { result in
            switch result {
            case .success(let data):
                ShareData.shareInfo.lastFetchedData = data
                self.map.earthQuackOnlineData = data
                completion(data)
                break
            case .failure(let error):
                print(error.localizedDescription)
                if let data = ShareData.shareInfo.lastFetchedData {
                    self.map.earthQuackOnlineData = data
                    AppUtility.showInfoMessage(message: "Loading offline data\nInternet problem")
                    completion(data)
                }
                else {
                    AppUtility.showInfoMessage(message: "Internet problem")
                    completion(nil)
                }
                
                break
            }
        }
    }
    
}
