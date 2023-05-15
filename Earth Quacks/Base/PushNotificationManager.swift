//
//  PushNotificationManager.swift
//  iEntry
//
//  Created by ZAFAR on 23/09/2021.
//

//import Foundation
//import FirebaseMessaging
//import UIKit
//import UserNotifications
//
//
//class NotificationManager:NSObject,MessagingDelegate,UNUserNotificationCenterDelegate {
//    
//    
//    func RegisterNotification() {
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().delegate = self
//            
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: { _, _ in }
//            )
//        } else {
//            let settings: UIUserNotificationSettings =
//            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(settings)
//        }
//        
//        UIApplication.shared.registerForRemoteNotifications()
//        
//    }
//    
//    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase registration token: \(fcmToken ?? "")")
//    }
//    
//    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
//        print("Received data message: \(remoteMessage.description)")
//    }
//    
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        
//        completionHandler([.alert, .badge, .sound])
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print(response)
//    }
//}
