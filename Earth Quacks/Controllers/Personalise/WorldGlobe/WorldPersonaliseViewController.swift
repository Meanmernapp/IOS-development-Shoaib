//
//  WorldPersonaliseViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 07/04/2023.
//

import UIKit
import Lottie

class WorldPersonaliseViewController: BaseViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    @IBOutlet weak var titleLbl: UILabel!

    
    //MARK: - Variables

    private var animationView: LottieAnimationView?
    var loading = true
    var count = 0
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView = .init(name: "Earth")
        animationView!.frame = lottieAnimationView.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView!.animationSpeed = 0.5
        lottieAnimationView!.addSubview(animationView!)
        animationView!.play()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateLoadingLabel()
    }
    
    @objc func animateLoadingLabel()
    {
        if loading
        {
            if titleLbl.text == "Personalizing\nyour experience..."
            {
                titleLbl.text = "Personalizing\nyour experience"
            }
            else
            {
                titleLbl.text = "\(titleLbl.text ?? "Personalizing\nyour experience")."
            }
            count += 1
            if count >= 5 {loading = false}
            perform(#selector(animateLoadingLabel), with: nil, afterDelay: 1)
        }
        else {
            self.coordinator?.configPage()
        }
    }
    
}
