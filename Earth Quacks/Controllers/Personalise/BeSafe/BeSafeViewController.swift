//
//  BeSafeViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 07/04/2023.
//

import UIKit
import Lottie
import CoreLocation
import OneSignal

class BeSafeViewController: BaseViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    
    //MARK: - Variables
    var viewModel : BaseViewModel?
    private var animationView: LottieAnimationView?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = BaseViewModel()
        animationView = .init(name: "Circles")
        animationView!.frame = lottieAnimationView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        lottieAnimationView!.addSubview(animationView!)
        animationView!.play()
    }
    
    
    @IBAction func continueAction(_ sender: Any) {
        if viewModel?.remoteConfig["permissions_push_ask"].numberValue ?? 1 == 1 {
            OneSignal.promptForPushNotifications(userResponse: { accepted in
              print("User accepted notifications: \(accepted)")
                Global.shared.userConfig.notificationsCheck = accepted
            })
        }
        coordinator?.worldGlobePage()
    }
    
}
