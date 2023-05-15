//
//  EarthQuackMagValueViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 07/04/2023.
//

import UIKit
import Amplitude

class EarthQuackMagValueViewController: BaseViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var continueBtn: UIButton!
    //MARK: - Variables
    
    var viewModel : BaseViewModel?
    
    //MARK: - LifeCycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = BaseViewModel()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        Amplitude.instance().logEvent("\(viewModel?.mags[viewModel?.selectedIndexForMag ?? Constant.defaultIndex] ?? Constant.defaultMag)")
        viewModel?.setupMag(selectedMag: viewModel?.mags[viewModel?.selectedIndexForMag ?? Constant.defaultIndex] ?? Constant.defaultMag)
        coordinator?.beSafePage()
        
    }
    
    func makeButton() {
        if viewModel?.selectedIndexForMag == -1 {
            continueBtn.alpha = 0.25
            continueBtn.isEnabled = false
        }
        else {
            continueBtn.alpha = 1
            continueBtn.isEnabled = true
        }
    }
    
}

extension EarthQuackMagValueViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.makeButton()
        return viewModel?.magTitle.count ?? Constant.defaultIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(MagTableViewCell.self, indexPath: indexPath)
        if viewModel?.selectedIndexForMag == indexPath.row {
            cell.mainView.backgroundColor = .black
            cell.magTitle.textColor = .white
        }
        else {
            cell.mainView.backgroundColor = UIColor(hexString: "B5B9CC",alpha: 0.15)
            cell.magTitle.textColor = .black
        }
        cell.config(title: viewModel?.magTitle[indexPath.row])
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.selectedIndexForMag = indexPath.row
        viewModel?.setupMag(selectedMag: viewModel?.mags[indexPath.row] ?? Constant.defaultMag)
        Constant.defaultMag = viewModel?.selectedMag ?? 1.0
        Global.shared.userConfig.defaultMag = self.mags[indexPath.row]
        Global.shared.userConfig.defaultMagIndex = indexPath.row
        self.tableView.reloadData()
    }
    
}

