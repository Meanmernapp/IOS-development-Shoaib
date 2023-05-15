//
//  Global.swift
//  Vocab
//
//  Created by Shoaib on 26/12/2021.
//

import Foundation
import UIKit
import FirebaseRemoteConfig
import CoreLocation

class Global {
    
    class var shared : Global {
        struct Static {
            static let instance : Global = Global()
        }
        return Static.instance
    }
    var userConfig = UserConfig()
    var annonymousID = ""
    var playerId = ""
    var token = ""
    var miles = 1000.0
    var changeAppearForList = false
    var changeAppearForMap = false
    var distanceARRAY :  [CLLocationDistance] = []
}
