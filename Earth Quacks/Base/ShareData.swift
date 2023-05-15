//
//  UserData.swift
//  Earth Quacks
//
//  Created by Shoaib on 05/03/2023.
//

import Foundation
import UIKit

class ShareData {
    static let shareInfo = ShareData()
    private init (){}
    
    var userConfig: UserConfig? {
        get {
            return UserDefaults.standard.retrieve(object: UserConfig.self, fromKey: "UserConfig")
        }
        set {
            UserDefaults.standard.save(customObject: newValue, inKey: "UserConfig")
        }
    }
    
    var lastFetchedData: EarthQuackModel? {
        get {
            return UserDefaults.standard.retrieve(object: EarthQuackModel.self, fromKey: "EarthQuackModel")
        }
        set {
            UserDefaults.standard.save(customObject: newValue, inKey: "EarthQuackModel")
        }
    }
    
    var isAlreadyLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isAlreadyLogin")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isAlreadyLogin")
        }
    }
    var lastPushToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "lastPushToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastPushToken")
        }
    }

}


extension UserDefaults {

   func save<T:Encodable>(customObject object: T, inKey key: String) {
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(object) {
           self.set(encoded, forKey: key)
       }
   }

   func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
       if let data = self.data(forKey: key) {
           let decoder = JSONDecoder()
           if let object = try? decoder.decode(type, from: data) {
               return object
           }else {
               print("Couldnt decode object")
               return nil
           }
       }else {
           print("Couldnt find key")
           return nil
       }
   }

}
