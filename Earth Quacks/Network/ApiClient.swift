//
//  ApiClient.swift
//  BCAST
//
//  Created by Shoaib on 28/02/2023.
//

import Foundation
import UIKit

//MARK: - Enum
enum APIError: Error {
    case internalError
    case serverError
    case parsingError
}

typealias Parameters = [String: Any]

//MARK: - Network Class

class ApiClient {
    
    //MARK: - Statics
    
    class var shared : ApiClient {
        struct Static {
            static let instance : ApiClient = ApiClient()
        }
        return Static.instance
    }
    let bundleID = Bundle.main.bundleIdentifier ?? ""
    let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    //MARK: - Variables

    private enum Method:String {
        case GET
        case POST
        case PATCH
    }
    
    //MARK: - APIs
    
    
    
    //MARK: - Api's
    
    func getEarthQuacks(distance:Double = Global.shared.userConfig.miles, dateFrom:String,dateTo:String,magnitudeFrom:Double,magnitudeTo:Double,depthFrom:Double,depthTo:Double,page:Int,pageSize:Int,fromMap:Bool = false,topRightLat:Double = 0.0,topRightLong:Double = 0.0,topLeftLat:Double = 0.0,topLeftLong:Double = 0.0,bottomRightLat:Double = 0.0,bottomRightLong:Double = 0.0,bottomLeftLat:Double = 0.0,bottomLeftLong:Double = 0.0,completion: @escaping (Result<EarthQuackModel, APIError>) -> Void) {
        
        var url = ConstantUrl.URLs.GET_EARTH_QUACKS + "?dateFrom=\(dateFrom)&dateTo=\(dateTo)&magnitudeFrom=\(magnitudeFrom)&magnitudeTo=\(magnitudeTo)&depthFrom=\(depthFrom)&depthTo=\(depthTo)&page=\(page)&pageSize=\(pageSize)&distance=\(distance)&centerLatitude\(Global.shared.userConfig.lat)&centerLongitude\(Global.shared.userConfig.long)"
        
        if fromMap {
            url = ConstantUrl.URLs.GET_EARTH_QUACKS + "?dateFrom=\(dateFrom)&dateTo=\(dateTo)&magnitudeFrom=\(magnitudeFrom)&magnitudeTo=\(magnitudeTo)&depthFrom=\(depthFrom)&depthTo=\(depthTo)&pointTopLeftLatitude=\(topLeftLat)&pointTopLeftLongitude=\(topLeftLong)&pointTopRightLatitude=\(topRightLat)&pointTopRightLongitude=\(topRightLong)&pointBottomLeftLatitude=\(bottomLeftLat)&pointBottomLeftLongitude=\(bottomLeftLong)&pointBottomRightLatitude=\(bottomRightLat)&pointBottomRightLongitude=\(bottomRightLong)&distance=\(distance)&centerLatitude\(Global.shared.userConfig.lat)&centerLongitude\(Global.shared.userConfig.long)"
        }

        request(url: url, params: nil, method: .GET,getAuth: true, completion: completion)
    }
    
    func getNotification(point:Int,completion: @escaping (Result<NotificationModelData, APIError>) -> Void) {
        let url = ConstantUrl.URLs.NOTIFICATION_POINT + "?single=" + "\(point)"
        request(url: url, params: nil, method: .GET,getAuth: true, completion: completion)
    }
    
    func pushToken(params:[String:Any],completion: @escaping (Result<PushTokenData, APIError>) -> Void) {
        request(url: ConstantUrl.URLs.PUSH_TOKEN, params: params, method: .POST, completion: completion)
    }

    func updateDevice(params:[String:Any],completion: @escaping (Result<DeviceModelData, APIError>) -> Void) {
        request(url: ConstantUrl.URLs.ACCOUNT_DEVICE, params: params, method: .POST,getAuth: true, completion: completion)
    }

    //MARK: - Master
    
    
    //MARK: - CHAT
    
    //MARK: - Private Request
    
    private func request<T: Codable>(url: String,params:Parameters?, method: Method,getAuth:Bool = false,verifyPassword:Bool = false,
                                  completion: @escaping((Result<T, APIError>) -> Void)) {
        guard let url = URL(string: url)
        else { completion(.failure(.internalError)); return }
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
//        if params != nil {
//            let data = try! JSONSerialization.data(withJSONObject: params ?? [:], options: JSONSerialization.WritingOptions.prettyPrinted)
//            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//            if let json = json {
//                print(json)
//            }
//            let jsonData = json!.data(using: String.Encoding.utf8.rawValue);
//            request.httpBody = jsonData
//        }
//
        request.allHTTPHeaderFields = ["Content-Type": "application/json","Accept-Charset":"utf-8","X-App-Device-Id":deviceID,"X-App-Package-Name":bundleID,"X-App-Package-Version":appVersion,"X-App-Api-Key":"4ab66aa9717268f69956451800fdb834ba89e618f08ba6a9c26942ca97e639ed"]
        call(with: request, completion: completion)
    }
    
    
    //MARK: - Generic
    
    
    private func call<T: Codable> (with request: URLRequest,completion: @escaping( (Result<T, APIError>) -> Void)) {
        Utility.showLoading()
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            Utility.hideLoading()
            guard error == nil
            else {
                completion(.failure(.serverError))
                return }
            do {
                guard let data = data else { completion(.failure(.serverError)); return }
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                print(request.url?.absoluteString ?? "")
                print("👏👏👏👏👏👏👏👏👏👏👏👏👏👏👏👏👏👏👏👏👏👏")
                print("/////////////////////////////////////////////////")
                print(object)
                print("/////////////////////////////////////////////////")
                completion(Result.success(object))
            } catch {
                print("🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲")
                print("/////////////////////////////////////////////////")
                print(request.url?.absoluteString ?? "")
                print("/////////////////////////////////////////////////")
                completion(Result.failure(.parsingError))
            }}
        dataTask.resume()
        
    }

}
