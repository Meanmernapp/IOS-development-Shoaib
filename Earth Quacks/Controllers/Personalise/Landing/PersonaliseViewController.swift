//
//  PersonaliseViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 07/04/2023.
//

import UIKit
import FirebaseRemoteConfig

class PersonaliseViewController: BaseViewController {
    
    //MARK: - Variables

    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - IBAction
    

    @IBAction func privacyAction(_ sender: Any) {
        coordinator?.webPage(isForPrivacy: true)
    }
    
    @IBAction func termAction(_ sender: Any) {
        coordinator?.webPage(isForPrivacy: false)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        coordinator?.locationPage()
    }

}
