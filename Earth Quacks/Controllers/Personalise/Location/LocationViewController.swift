//
//  LocationViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 07/04/2023.
//

import UIKit
import Lottie

class LocationViewController: BaseViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    
    //MARK: - Variables

    private var animationView: LottieAnimationView?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView = .init(name: "Map-Flat")
        animationView!.frame = lottieAnimationView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        lottieAnimationView!.addSubview(animationView!)
        animationView!.play()
    }
    
    
    @IBAction func continueAction(_ sender: Any) {
        coordinator?.distancePage()
    }
    
}

