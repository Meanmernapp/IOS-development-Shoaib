//
//  ListTableViewCell.swift
//  Earth Quacks
//
//  Created by Shoaib on 20/04/2023.
//

import UIKit
import CoreLocation

class ListTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var magLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var mileLbl: UIButton!
    @IBOutlet weak var depthLbl: UIButton!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    //MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    //MARK: -  Functions
    
    func config(data:EarthquakesData?) {
        if let mag = data?.mag {
            setupMag(mag: mag)
        }
        else {
            self.colorView.backgroundColor = UIColor(hexString: "A6BE80")
        }
        self.magLbl.text = String(format: "%.1f", data?.mag ?? 0.0)
        self.placeLbl.text = "\(data?.title ?? "")"
        self.depthLbl.setTitle(String(format: "  %.1f mi", data?.depth ?? 0.0), for: .normal)
        self.mileLbl.setTitle(String(format: "  %.1f mi", data?.distance ?? 0.0), for: .normal)
        let date = data?.created?.split(separator: " ").first
        let time = data?.created?.split(separator: " ").last
        self.dateLbl.text = "\(date ?? "")"
        self.timeLbl.text = "\(time ?? "")"
    }
    
    func setupMag(mag:Double) {
        if mag > 0 && mag < 2.5 {
            self.colorView.backgroundColor = UIColor(hexString: "A6BE80")
        }
        else if mag > 2.5 && mag < 3.5 {
            self.colorView.backgroundColor = UIColor(hexString: "99C933")
        }
        else if mag > 3.5 && mag < 4.5 {
            self.colorView.backgroundColor = UIColor(hexString: "F3B61A")
        }
        else if mag > 4.5 && mag < 5.5 {
            self.colorView.backgroundColor = UIColor(hexString: "FF5C00")
        }
        else if mag > 5.5 && mag < 6.5 {
            self.colorView.backgroundColor = UIColor(hexString: "FF271A")
        }
        else if mag > 6.5 && mag < 7.5 {
            self.colorView.backgroundColor = UIColor(hexString: "FF000F")
        }
        else if mag > 7.5 && mag < 8.5 {
            self.colorView.backgroundColor = UIColor(hexString: "FF006B")
        }
        else {
            self.colorView.backgroundColor = UIColor(hexString: "FF006B")
        }
        
    }
    
}

