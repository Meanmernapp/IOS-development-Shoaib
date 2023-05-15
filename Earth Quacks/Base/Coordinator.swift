//
//  Coordinator.swift
//  Vocab
//
//  Created by Shoaib on 26/12/2021.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
}

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
    }
    func webPage(isForPrivacy:Bool) {
        let vc = WebViewController(nibName: "WebViewController", bundle: nil)
        vc.coordinator = self
        vc.isForPrivacy = isForPrivacy
        navigationController.pushViewController(vc, animated: true)
    }
    func supportPage() {
        let vc = SupportPageViewController(nibName: "SupportPageViewController", bundle: nil)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    func configPage() {
        let vc = UserConfigurationViewController(nibName: "UserConfigurationViewController", bundle: nil)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    func worldGlobePage() {
        let vc = WorldPersonaliseViewController(nibName: "WorldPersonaliseViewController", bundle: nil)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    func beSafePage() {
        let vc = BeSafeViewController(nibName: "BeSafeViewController", bundle: nil)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    func earthQuckMagPage() {
        let vc = EarthQuackMagValueViewController(nibName: "EarthQuackMagValueViewController", bundle: nil)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    func distancePage() {
        let vc = ChooseDistanceViewController(nibName: "ChooseDistanceViewController", bundle: nil)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    func locationPage() {
        let vc = LocationViewController(nibName: "LocationViewController", bundle: nil)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    func personlisePage() {
        let vc = PersonaliseViewController(nibName: "PersonaliseViewController", bundle: nil)
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: true)
    }
    func tabbarPage() {
        let vc :HomeTabbarViewController = UIStoryboard.controller()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: true)
    }
    func popVc() {
        navigationController.popViewController(animated: true)
    }
    
}

//MARK: - StoryBoard Reference
extension UIStoryboard {
    
    class func controller  <T: UIViewController> (storyboardName : String = "Main") -> T {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: T.className) as! T
    }
}

//MARK: - NSObject
extension NSObject {
    class var className: String {
        return String(describing: self.self)
    }
}
