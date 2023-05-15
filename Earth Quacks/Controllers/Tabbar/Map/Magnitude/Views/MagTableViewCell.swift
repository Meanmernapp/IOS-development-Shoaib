//
//  MagTableViewCell.swift
//  Earth Quacks
//
//  Created by Shoaib on 30/03/2023.
//

import UIKit

class MagTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var magTitle: UILabel!
    
    //MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: -  Functions
    
    func config(title:String?) {
        self.magTitle.text = title
    }
}
