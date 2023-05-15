//
//  AppUtility.swift
//  Earth Quacks
//
//  Created by Shoaib on 05/03/2023.
//

import Foundation
import SwiftMessages
import UIKit


class AppUtility {
    
    class func showErrorMessage(message:String) {
        DispatchQueue.main.async {
            let error = MessageView.viewFromNib(layout: .tabView)
            error.configureTheme(.error)
            error.configureContent(title: "Error", body: message)
            error.button?.isHidden = true
            SwiftMessages.show(view: error)
            
        }
    }
    
    class func showSuccessMessage(message:String) {
        DispatchQueue.main.async {
            let success = MessageView.viewFromNib(layout: .tabView)
            success.configureTheme(.success)
            success.configureContent(title: "Success", body: message)
            success.button?.isHidden = true
            SwiftMessages.show(view: success)
        }
        
    }
    
    class func showInfoMessage(message:String) {
        DispatchQueue.main.async {
            let info = MessageView.viewFromNib(layout: .tabView)
            info.configureTheme(.info)
            info.configureContent(title: "Info", body: message)
            info.button?.isHidden = true
            SwiftMessages.show(view: info)
            
        }
    }
    
    
    
}
