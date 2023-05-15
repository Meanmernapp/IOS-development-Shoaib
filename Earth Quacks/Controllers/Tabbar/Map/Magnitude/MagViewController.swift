//
//  MagViewController.swift
//  Earth Quacks
//
//  Created by Shoaib on 30/03/2023.
//

import UIKit


class MagViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var magBtn: UIButton!
    
    //MARK: - Variables
    
    let magTitle = ["All above 1.0","More than 2.0","More than 3.0","More than 4.0","More than 5.0"]
    let mags = [1.0,2.0,3.0,4.0,5.0]
    var selectedMag = 1.0
    var selectedIndex = -1
    var callback : ((Double) -> Void)?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - IBAction
    
    @IBAction func selectAction(_ sender: Any) {
        callback?(selectedMag)
        self.dismiss(animated: true)
    }
    
}


//MARK: - TableView Extention

extension MagViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return magTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(MagTableViewCell.self, indexPath: indexPath)
        if selectedIndex == indexPath.row {
            cell.mainView.backgroundColor = .black
            cell.magTitle.textColor = .white
        }
        else {
            cell.mainView.backgroundColor = UIColor(hexString: "B5B9CC",alpha: 0.15)
            cell.magTitle.textColor = .black
        }
        cell.config(title: self.magTitle[indexPath.row])
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndex = indexPath.row
        self.selectedMag = mags[indexPath.row]
        self.magBtn.setTitle("Select \(self.magTitle[indexPath.row])", for: .normal)
        self.tableView.reloadData()
    }
    
}
