//
//  MapViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 30/03/2023.
//

import UIKit
import MapKit
import Amplitude
import FittedSheets

class MapViewController: BaseViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var magBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var playPauseBtn: UIButton!
    
    //MARK: - Variables
    
    var viewModel : MapViewModel?
    var days = 0
    var datesSelecteed : [String] = []
    var timer : Timer?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelsSetup()
        self.setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Amplitude.instance().logEvent("Map")
        if Global.shared.changeAppearForMap {
            self.labelsSetup()
            Global.shared.changeAppearForMap = false
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func magAction(_ sender: Any) {
        let magController = MagViewController(nibName: Constant.viewcontroller.MapViewController, bundle: nil)
        magController.callback = { magValue in
            self.settingUpByMag(magValue: magValue)
        }
        let sheetController = SheetViewController(controller: magController)
        self.present(sheetController, animated: true, completion: nil)
    }
    
    @IBAction func dateAction(_ sender: Any) {
        let controller = CalenderViewController(monthsLayout: .vertical)
        controller.callback  = { startDate , endDate in
            self.settingUpByDate(startDate: startDate, endDate: endDate)
        }
        let sheetController = SheetViewController(controller: controller)
        self.present(sheetController, animated: true, completion: nil)
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        if sender.isSelected {
            self.timer?.invalidate()
        }
        else
        {
            self.timer = Timer.scheduledTimer(timeInterval: 1.5,
                target: self,
                selector: #selector(self.update),
                userInfo: nil,
                repeats: true)
            
        }
        
        sender.isSelected = !sender.isSelected
        
    }
    
    @IBAction func allAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            settingUpAll()
        }
        else {
            settingUpFilter()
        }
        
    }
    
    @IBAction func sliderValue(_ sender: UISlider) {
        if self.datesSelecteed.count != 0 {
            let filteredArray = self.viewModel?.map.earthQuackOnlineData?.content?.earthquakes?.filter { $0.created?.contains(self.datesSelecteed[Int(sender.value)]) ?? false }
            self.viewModel?.map.sliderFilter = filteredArray
            if let filter = filteredArray {
                if filter.count != 0 {
                    print("\(self.datesSelecteed[Int(sender.value)])")
                    self.setupViewForMap(isFromSlider: true, dataArray: filter)
                }
                else {
//                    AppUtility.showInfoMessage(message: "No earthquack on \(self.datesSelecteed[Int(sender.value)])")
                    print("No earthquack on \(self.datesSelecteed[Int(sender.value)])")
                }
            }
        }
    }
    
    @IBAction func locationAction(_ sender: Any) {
        settingUpLocation()
    }
    
    @IBAction func layersAction(_ sender: Any) {
        layerFilter()
    }
    
    //MARK: -  Functions
    
    func setupViewModel() {
        self.viewModel = MapViewModel()
        self.viewModel?.getOnlineEarthQuack(dateFrom: Global.shared.userConfig.defaultStartingDate,dateTo: Global.shared.userConfig.defaultEndingDate,magnitudeFrom: Global.shared.userConfig.defaultMag,completion: { _ in
            self.setupViewForMap(isFromSlider: false)
        })
    }
    
}
