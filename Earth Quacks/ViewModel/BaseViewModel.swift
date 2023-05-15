//
//  DistanceViewModel.swift
//  Earth Quacks
//
//  Created by Shoaib on 07/04/2023.
//

import Foundation
import CoreLocation
import UserNotifications
import FirebaseRemoteConfig

//MARK: - UserConfiguration
struct UserConfig : Codable {
    var defaultMag = 1.0
    var defaultMagIndex = 0
    var defaultStartingDate = Constant.defaultStartingDate
    var defaultEndingDate = Constant.defaultEndingDate
    var alertDistance = 0
    var lat = 0.0
    var long = 0.0
    var notificationsCheck = false
    var location = false
    var miles = 999999990000000000.0
}

class BaseViewModel : NSObject {
    
    let current = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()
    let remoteConfig = RemoteConfig.remoteConfig()
    let distanceTitle = ["All over the world","Within 50 miles","Within 100 miles","Within 250 miles","Within 500 miles"]
    var selectedIndex = -1
    
    //MARK: - For EarthQuackMag
    let magTitle = ["All above 1.0","More than 2.0","More than 3.0","More than 4.0","More than 5.0"]
    let mags = [1.0,2.0,3.0,4.0,5.0]
    var selectedMag = 1.0
    var selectedIndexForMag = -1
    
    func getLocation(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func setupMag(selectedMag:Double) {
        self.selectedMag = selectedMag
    }
}

extension BaseViewModel : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        Global.shared.userConfig.lat = locValue.latitude
        Global.shared.userConfig.long = locValue.longitude
        Global.shared.userConfig.location = true
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
