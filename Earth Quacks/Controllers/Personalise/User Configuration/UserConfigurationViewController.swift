//
//  UserConfigurationViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 10/04/2023.
//

import UIKit

class UserConfigurationViewController: BaseViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var magLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUi()
    }
    
    //MARK: - IBAction
    
    @IBAction func continueAction(_ sender: Any) {
        ShareData.shareInfo.userConfig = Global.shared.userConfig
        coordinator?.supportPage()
    }
    
    //MARK: -  Functions
    func setupUi() {
        let userConfig = Global.shared.userConfig
        notificationLbl.text = userConfig.notificationsCheck ? "✅" : "🚫"
        locationLbl.text = userConfig.location ? "✅" : "🚫"
        distanceLbl.text = self.distanceTitle[userConfig.alertDistance]
        magLbl.text = self.magTitle[userConfig.defaultMagIndex]
    }
}
