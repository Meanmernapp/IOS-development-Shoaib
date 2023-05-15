//
//  AppDelegate.swift
//  Earth Quacks
//
//  Created by Shoaib on 30/03/2023.
//

import UIKit
import IQKeyboardManagerSwift
import AppTrackingTransparency
import Amplitude
import OneSignal
import Firebase
import FirebaseRemoteConfig

@main
class AppDelegate: UIResponder, UIApplicationDelegate , UISceneDelegate {
    
    var window: UIWindow?
    var coordinator: MainCoordinator?
    
    let deviceType = UIDevice.current.model
    let deviceModel = UIDevice.current.modelName
    let deviceManufacturer = UIDevice.current.manufacturer
    let deviceLocale = Locale.current
    let deviceTimezone = TimeZone.current
    let deviceOSName = UIDevice.current.systemName
    let deviceOSVersion = UIDevice.current.systemVersion
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Global.shared.userConfig = ShareData.shareInfo.userConfig ?? UserConfig()
        self.datesSetup()
        FirebaseApp.configure()
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("e591145d-2f91-4269-9f5a-cf6953fff5a0")
        Amplitude.instance().trackingSessionEvents = true
        Amplitude.instance().initializeApiKey("905ab682e83dfc6109a83f62b61c3d7a")
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        let navController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navController)
        if ShareData.shareInfo.userConfig ==  nil {
            self.coordinator?.personlisePage()
        }
        else {
            self.coordinator?.tabbarPage()
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        DispatchQueue.main.async {
            self.requestPermission()
        }
        DispatchQueue.global(qos: .background).async {
            
            print(self.getOneSignalPushToken())
            print(self.getOneSignalPlayerId())
            self.remoteConfigSetup()
            self.firebaseAny()
            self.pushToken()
            self.updateDevice()
        }

        

        return true
    }
    
    //MARK: - Terminate app
    
    func applicationWillTerminate(_ application: UIApplication) {
        Amplitude.instance().logEvent("app_close")
    }
    
    //MARK: - APi calls
    func datesSetup() {
        let dateFormatterPrint2 = DateFormatter()
        dateFormatterPrint2.dateFormat = Constant.defaultDateFormatter
        let start = CalendarHelper().addDays(date: Date(), days: -7)
        let end = Date()
        Global.shared.userConfig.defaultStartingDate = dateFormatterPrint2.string(from: start)
        Global.shared.userConfig.defaultEndingDate = dateFormatterPrint2.string(from: end)
    }

    
    func pushToken() {
        if ShareData.shareInfo.lastPushToken != getOneSignalPushToken() {
            ApiClient.shared.pushToken(params: ["push_token":getOneSignalPushToken(),"one_signal_player_id": getOneSignalPlayerId()]) { result in
                switch result {
                case .success(let data):
                    print(data)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
            
        }
    }
    
    func updateDevice() {
        ApiClient.shared.updateDevice(params: ["device_type":deviceType,"device_model":deviceModel,"device_manufacturer":deviceManufacturer,"device_locale":deviceLocale,"device_timezone":deviceTimezone,"os_name":deviceOSName,"os_version":deviceOSVersion]) { result in
            switch result {
            case .success(let data):
                print(data)
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    //MARK: -  Remote Configure
    
    func remoteConfigSetup() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.fetch() { [weak self] status, error in
            if status == .success {
                remoteConfig.activate()
                print(self as Any)
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    //MARK: - Tracking
    
    func requestPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Authorized")
//                    AppUtility.showSuccessMessage(message: "Continue with Tracking")
                case .denied:
                    print("Denied")
//                    AppUtility.showInfoMessage(message: "Please enable from setting")
                case .notDetermined:
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
    
    //MARK: - Firebase Auth
    func firebaseAny() {
        Auth.auth().signInAnonymously() { authResult, error in
            if let error = error {
                print("Error signing in anonymously: \(error.localizedDescription)")
            } else {
                let userID = authResult!.user.uid
                print("User is signed in anonymously with uid: \(authResult!.user.uid)")
                Global.shared.annonymousID = userID
                Amplitude.instance().setUserId(userID)
                Amplitude.instance().logEvent("app_start")
            }
        }
    }
    
    
    //MARK: - One Signal
    
    // Get OneSignal push notification token
    func getOneSignalPushToken() -> String {
        let token = OneSignal.getDeviceState()?.pushToken ?? ""
        Global.shared.token = token
        ShareData.shareInfo.lastPushToken = token
        return token
    }
    // Get OneSignal push notification token
    func getOneSignalPlayerId() -> String {
        let playerId = OneSignal.getDeviceState()?.userId ?? ""
        Global.shared.playerId = playerId
        return playerId
    }
}

