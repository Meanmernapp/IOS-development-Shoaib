//
//  ListViewModel.swift
//  Earth Quacks
//
//  Created by Shoaib on 28/04/2023.
//

import Foundation
import UIKit

class ListViewModel : NSObject {
    var data : [EarthquakesData]?
    var totalData : EarthQuackModel?
    var filterData : [EarthquakesData]?
    var count = 50
    var searching = false

    
    
    func getOnlineEarthQuack(distance:Double = 9999999999.0,dateFrom:String = "2005-03-01",dateTo:String = "2023-03-23",magnitudeFrom:Double = 5.0,magnitudeTo:Double = 10.0,depthFrom:Double = 0.0,depthTo:Double = Global.shared.miles,page:Int = 1,pageSize:Int = 10,completion: @escaping (EarthQuackModel?) -> Void) {
        ApiClient.shared.getEarthQuacks(distance: distance, dateFrom: dateFrom, dateTo: dateTo, magnitudeFrom: magnitudeFrom, magnitudeTo: magnitudeTo, depthFrom: depthFrom, depthTo: depthTo, page: page, pageSize: pageSize) { result in
            switch result {
            case .success(let data):
                ShareData.shareInfo.lastFetchedData = data
                completion(data)
                break
            case .failure(let error):
                print(error.localizedDescription)
                if let data = ShareData.shareInfo.lastFetchedData {
                    AppUtility.showInfoMessage(message: "Loading offline data\nInternet problem")
                    completion(data)
                }
                else
                {
                    AppUtility.showInfoMessage(message: "Internet problem")
                    completion(nil)
                }
                
                break
            }
        }
    }
}
