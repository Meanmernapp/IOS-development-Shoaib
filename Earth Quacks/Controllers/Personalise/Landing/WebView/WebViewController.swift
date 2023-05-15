//
//  WebViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 10/04/2023.
//

import UIKit
import WebKit
import FirebaseRemoteConfig

class WebViewController: BaseViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var webVoiew: WKWebView!
    
    //MARK: - Variables
    
    var isForPrivacy = false
    let remoteConfig = RemoteConfig.remoteConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.remoteCofig(isForPrivacy: self.isForPrivacy)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if let coordinator {
            coordinator.popVc()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func remoteCofig(isForPrivacy:Bool) {
        
        let privacyPolicy = self.remoteConfig["privacy_policy"].stringValue ?? "https://iquake.app/policy.html"
        let termsOfUse = self.remoteConfig["terms_of_use"].stringValue ?? "https://iquake.app/terms.html"
        if isForPrivacy {
            DispatchQueue.main.async {
                self.webVoiew.load(URLRequest(url: URL(string: privacyPolicy)!))
            }
            
        }
        else {
            DispatchQueue.main.async {
                self.webVoiew.load(URLRequest(url: URL(string: termsOfUse)!))
            }
        }
    }
    
    
}
