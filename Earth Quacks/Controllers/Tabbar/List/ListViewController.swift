//
//  ListViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 13/04/2023.
//

import UIKit
import FittedSheets
import Amplitude


class ListViewController: BaseViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var mileBtn: UIButton!
    @IBOutlet weak var magBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    //MARK: - Variables
    
    var viewModel : ListViewModel?
    let refreshControl = UIRefreshControl()
    var isLoadingList : Bool = false
    var itemsToSort: [EarthquakesData] = []
    var miles : Double = 1000
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ListViewModel()
        self.labelsSetup()
        self.searchBar.delegate = self
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        setupViewModel(pageSize: self.viewModel?.count ?? 50)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Amplitude.instance().logEvent("List")
        self.labelsSetup()
        if Global.shared.changeAppearForList {
            setupViewModel(pageSize: self.viewModel?.count ?? 50)
            Global.shared.changeAppearForList = false
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.endRefreshing()
        self.viewModel?.count = 50
        setupViewModel(pageSize: self.viewModel?.count ?? 50)
    }
    
    //MARK: - IBAction
    
    @IBAction func sendAction(_ sender: Any) {
        Amplitude.instance().logEvent("Send")
        self.setupViewModel(pageSize: 50)
    }
    
    @IBAction func sortAction(_ sender: Any) {
        Amplitude.instance().logEvent("Sort")
        
        let alert = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        
        let byDateAction = UIAlertAction(title: "By Time", style: .default) { action in
            self.sortItems(by: .byDate)
        }
        alert.addAction(byDateAction)
        
        let byMagnitudeAction = UIAlertAction(title: "By Magnitude", style: .default) { action in
            self.sortItems(by: .byMagnitude)
        }
        alert.addAction(byMagnitudeAction)
        
        let byDistanceAction = UIAlertAction(title: "By Distance Away", style: .default) { action in
            self.sortItems(by: .byDistance)
        }
        alert.addAction(byDistanceAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        self.tableView.reloadData()
    }
    
    @IBAction func magAction(_ sender: Any) {
        let magController = MagViewController(nibName: Constant.viewcontroller.MapViewController, bundle: nil)
        magController.callback = { magValue in
            Amplitude.instance().logEvent("\(magValue)")
            self.viewModel?.count = 50
            Global.shared.userConfig.defaultMag = magValue
            self.magBtn.setTitle("M \(magValue)+", for: .normal)
            self.setupViewModel(pageSize : self.viewModel?.count ?? 50)
        }
        let sheetController = SheetViewController(controller: magController)
        self.present(sheetController, animated: true, completion: nil)
    }
    
    @IBAction func mileAction(_ sender: Any) {
        let vc = ChooseDistanceViewController(nibName: "ChooseDistanceViewController", bundle: nil)
        vc.isFromSetting = true
        vc.callback = { distance in
            if distance == 1000 {
                self.mileBtn.setTitle("\(distance)+mi", for: .normal)
            }
            else {
                self.mileBtn.setTitle("\(distance)mi", for: .normal)
            }
            let distance = Double(distance)
            self.setupViewModel(distance: self.milesToMeters(distance), pageSize: 50)
            Global.shared.userConfig.miles = distance
            ShareData.shareInfo.userConfig = Global.shared.userConfig
        }
        vc.modalPresentationStyle = .popover
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func dateAction(_ sender: Any) {
        let controller = CalenderViewController(monthsLayout: .vertical)
        controller.callback  = { startDate , endDate in
            Amplitude.instance().logEvent("\(startDate) \(endDate)")
            self.viewModel?.count = 50
            self.settingUpByDate(startDate: startDate, endDate: endDate)
        }
        let sheetController = SheetViewController(controller: controller)
        self.present(sheetController, animated: true, completion: nil)
    }
    
}
