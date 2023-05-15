//
//  Constants.swift
//  BCAST
//
//  Created by Shoaib on 28/02/2023.
//

import Foundation


class ConstantUrl {
    static var BASE_URL : String { return "https://api.disaster.events/v1/" }

    struct URLs {
        
        //MARK: - NOTIFICATION
        
        static let NOTIFICATION_POINT = BASE_URL + "notification/point"
        
        //MARK: - ACCOUNT
        static let ACCOUNT_DEVICE = BASE_URL + "account/device"
        static let PUSH_TOKEN = BASE_URL + "account/push-token"
        
        //MARK: - EarthQuacks
//    http://api.disaster.events/v1/map/earthquake?dateFrom=2020-03-01&dateTo=2023-03-23&magnitudeFrom=0.0&magnitudeTo=10.0&depthFrom=0.0&depthTo=100.0&page=1&pageSize=5
        
        static let GET_EARTH_QUACKS = BASE_URL + "map/earthquake"
    }
    
}

//MARK: - App Constants

class Constant {
    static var defaultDateFormatter : String {"yyyy-MM-dd"}
    static var requireDateFormatter : String {"MMM d ''yy"}
    static var defaultStartingDate : String {"2022-01-01"}
    static var defaultEndingDate : String {"2023-03-01"}
    static var defaultMag : Double = 1.0
    static var defaultIndex : Int  {0}
    
    struct viewcontroller {
        static var MapViewController : String {"MagViewController"}
    }
    
}
