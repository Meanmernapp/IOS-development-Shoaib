//
//  SettingViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 13/04/2023.
//

import UIKit
import FittedSheets
import UserNotifications
import CoreLocation
import Amplitude

class SettingViewController: BaseViewController, CLLocationManagerDelegate {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var notificationBtn: UISwitch!
    @IBOutlet weak var locationBtn: UISwitch!
    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var magView: UIView!
    @IBOutlet weak var magValue: UILabel!
    @IBOutlet weak var radiusvalue: UILabel!
    
    @IBOutlet weak var contactUsView: UIView!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var termsView: UIView!
    
    //MARK: - Variables
    
    
    var notificationsEnabled = true
    let locationManager = CLLocationManager()
    var locationEnabled = true
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Amplitude.instance().logEvent("Setting")
        self.radiusvalue.text = distanceTitles[Global.shared.userConfig.alertDistance]
        self.magValue.text =  String(format: "%.1f+", Global.shared.userConfig.defaultMag)
    }
    
    //MARK: - IBAction
    
    @IBAction func locationAction(_ sender: UISwitch) {
        locationEnabled = sender.isOn
        
        if locationEnabled {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func notificationAction(_ sender: UISwitch) {
        notificationsEnabled = sender.isOn
        
        // Enable or disable notifications based on the switch state
        if notificationsEnabled {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                // Handle authorization request completion
            }
        } else {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                }
            }
        }
    }
    
    func setup() {
        // Set up location manager delegate
        locationManager.delegate = self
        
        // Set the initial switch state based on the location status
        locationBtn.isOn = locationEnabled
        
        // Request location authorization
        locationManager.requestWhenInUseAuthorization()
        
        notificationBtn.isOn = notificationsEnabled
        // Request notification authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            // Handle authorization request completion
        }
        
        
        self.radiusvalue.text = distanceTitles[Global.shared.userConfig.alertDistance]
        self.magValue.text =  String(format: "%.1f+", Global.shared.userConfig.defaultMag)
        let magGesture = UITapGestureRecognizer(target: self, action: #selector(magTap(_:)))
        magView.addGestureRecognizer(magGesture)
        let radiusGesture = UITapGestureRecognizer(target: self, action: #selector(radiusTap(_:)))
        radiusView.addGestureRecognizer(radiusGesture)
        let termsGesture = UITapGestureRecognizer(target: self, action: #selector(termsTap(_:)))
        termsView.addGestureRecognizer(termsGesture)
        let privacyGesture = UITapGestureRecognizer(target: self, action: #selector(privacyTap(_:)))
        privacyView.addGestureRecognizer(privacyGesture)
        let contactGesture = UITapGestureRecognizer(target: self, action: #selector(contactUsTap(_:)))
        contactUsView.addGestureRecognizer(contactGesture)
    }
    
    @objc func magTap(_ sender: UITapGestureRecognizer) {
        let magController = MagViewController(nibName: Constant.viewcontroller.MapViewController, bundle: nil)
        magController.callback = { magValue in
            Amplitude.instance().logEvent("\(magValue)")
            Global.shared.changeAppearForMap = true
            Global.shared.changeAppearForList = true
            Global.shared.userConfig.defaultMag = magValue
            ShareData.shareInfo.userConfig = Global.shared.userConfig
            self.magValue.text = String(format: "%.1f+", magValue)
        }
        let sheetController = SheetViewController(controller: magController)
        self.present(sheetController, animated: true, completion: nil)
    }
    
    @objc func radiusTap(_ sender: UITapGestureRecognizer) {
        let vc = ChooseDistanceViewController(nibName: "ChooseDistanceViewController", bundle: nil)
        vc.isFromSetting = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func termsTap(_ sender: UITapGestureRecognizer) {
        let vc = WebViewController(nibName: "WebViewController", bundle: nil)
        vc.isForPrivacy = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func privacyTap(_ sender: UITapGestureRecognizer) {
        let vc = WebViewController(nibName: "WebViewController", bundle: nil)
        vc.isForPrivacy = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func contactUsTap(_ sender: UITapGestureRecognizer) {

    }
    
    //MARK: - Extention
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            if locationManager.authorizationStatus == .authorizedWhenInUse {
                if locationEnabled {
                    locationManager.startUpdatingLocation()
                }
            } else {
                locationManager.stopUpdatingLocation()
            }
        } else {
            if locationEnabled {
                locationManager.startUpdatingLocation()
            }
            else {
                locationManager.stopUpdatingLocation()
            }
        }
    }

}
