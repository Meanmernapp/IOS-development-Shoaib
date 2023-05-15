//
//  ChooseDistanceViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 07/04/2023.
//

import UIKit
import Amplitude
import FirebaseRemoteConfig

class ChooseDistanceViewController: BaseViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var changeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationBtn: UIButton!
    
    //MARK: - Variables
    
    var viewModel : BaseViewModel?
    var isFromSetting = false
    var callback : ((Int) -> Void)?
    //MARK: - LifeCycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = BaseViewModel()
        if isFromSetting {
            self.locationLbl.isHidden = true
            self.locationBtn.setTitle("Continue", for: .normal)
            self.viewModel?.selectedIndex = Global.shared.userConfig.alertDistance
            self.tableView.reloadData()
        }
        makeButton()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if isFromSetting {
            Global.shared.changeAppearForMap = true
            Global.shared.changeAppearForList = true
            Amplitude.instance().logEvent(distanceTitles[Global.shared.userConfig.alertDistance])
            callback?(Int(distanceMiles[Global.shared.userConfig.alertDistance]))
            Global.shared.userConfig.miles = distanceMiles[Global.shared.userConfig.alertDistance]
            Global.shared.miles = distanceMiles[Global.shared.userConfig.alertDistance]
            ShareData.shareInfo.userConfig = Global.shared.userConfig
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
            
        }
        else {
            if viewModel?.remoteConfig["permissions_location_ask"].numberValue ?? 1 == 1 {
                viewModel?.getLocation()
            }
            coordinator?.earthQuckMagPage()
            
        }
    }
    
    func makeButton() {
        if viewModel?.selectedIndex == -1 {
            locationBtn.alpha = 0.25
            locationBtn.isEnabled = false
        }
        else {
            locationBtn.alpha = 1
            locationBtn.isEnabled = true
        }
    }
}

extension ChooseDistanceViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.makeButton()
        return viewModel?.distanceTitle.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(MagTableViewCell.self, indexPath: indexPath)
        if viewModel?.selectedIndex == indexPath.row {
            cell.mainView.backgroundColor = .black
            cell.magTitle.textColor = .white
        }
        else {
            cell.mainView.backgroundColor = UIColor(hexString: "B5B9CC",alpha: 0.15)
            cell.magTitle.textColor = .black
        }
        cell.config(title: viewModel?.distanceTitle[indexPath.row])
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.selectedIndex = indexPath.row
        if !isFromSetting {
            if viewModel?.selectedIndex == 0 {
                self.locationLbl.isHidden = true
                self.changeLbl.isHidden = false
            }
            else {
                self.locationLbl.isHidden = false
                self.changeLbl.isHidden = true
            }
            
        }
        else {
            self.locationLbl.isHidden = true
            self.changeLbl.isHidden = true
        }
        Global.shared.userConfig.alertDistance = viewModel?.selectedIndex ?? -1
        self.tableView.reloadData()
    }
    
}

