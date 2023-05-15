//
//  BaseViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 30/03/2023.
//

import UIKit
import HorizonCalendar
import StoreKit

struct LocationOfUser {
    var lat : Double?
    var long : Double?
    
    init(lat: Double? = nil, long: Double? = nil) {
        self.lat = lat
        self.long = long
    }
}
class BaseViewController: UIViewController {
    let distanceMiles = [1000.0,50.0,100.0,250.0,500.0]
    let distanceTitles = ["All over the world","50 miles","100 miles","250 miles","500 miles"]
    let distanceTitle = ["All over the world","Within 50 miles","Within 100 miles","Within 250 miles","Within 500 miles"]
    let magTitle = ["All above 1.0","More than 2.0","More than 3.0","More than 4.0","More than 5.0"]
    let mags = [1.0,2.0,3.0,4.0,5.0]
    //MARK: - Variables

    var coordinator : MainCoordinator?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Global.shared.miles = distanceMiles[Global.shared.userConfig.alertDistance]
    }
    
    func milesToMeters(_ miles: Double) -> Double {
        return miles * 1609.34
    }
    
    func appReview(){
        var count = UserDefaults.standard.integer(forKey: "processCompletedCountKey")
        count += 1
        UserDefaults.standard.set(count, forKey: "processCompletedCountKey")
        print("Process completed \(count) time(s).")
        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: "lastVersionPromptedForReviewKey")
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
            else { fatalError("Expected to find a bundle version in the info dictionary.") }
         if count >= 4 && currentVersion != lastVersionPromptedForReview {
             Task { @MainActor [weak self] in
                 try? await Task.sleep(nanoseconds: UInt64(2e9))
                 if let windowScene = self?.view.window?.windowScene,
                    self?.navigationController?.topViewController is BaseViewController {
                     if #available(iOS 14.0, *) {
                         SKStoreReviewController.requestReview(in: windowScene)
                         UserDefaults.standard.set(currentVersion, forKey:  "lastVersionPromptedForReviewKey")
                     } else {
                         
                     }
                     
                }
             }
         }
    }
    
}

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type, indexPath: IndexPath) -> T {
        self.register(UINib(nibName: String(describing: T.self), bundle: .main), forCellReuseIdentifier: String(describing: T.self))
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
        return cell
    }
}

extension UIColor {
    static var appColor: UIColor {
        return UIColor(red: 125/255.0, green: 157/255.0, blue: 21/255.0, alpha: 1)
    }
    convenience init(hexString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension UISegmentedControl {

    func setTitleColor(_ selectedColor: UIColor,_ unselectedColor: UIColor, state: UIControl.State = .normal) {
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectedColor
        ]
        self.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        let unselectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: unselectedColor
        ]
        self.setTitleTextAttributes(unselectedAttributes, for: .normal)
        
    }

}
