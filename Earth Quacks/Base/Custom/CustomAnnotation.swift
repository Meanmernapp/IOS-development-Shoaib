//
//  AnnotationPin.swift
//  Earth Quacks
//
//  Created by Shoaib on 30/03/2023.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var label: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, label: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.label = label
    }
}

class CustomAnnotationView: MKAnnotationView {
    var label: UILabel?
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        if let customAnnotation = annotation as? CustomAnnotation {
            let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            
            circleView.layer.addSublayer(UIColor.gradeint(view: circleView))
            circleView.layer.cornerRadius = 20
            circleView.clipsToBounds = true
            circleView.layer.borderColor = UIColor.white.cgColor
            circleView.layer.borderWidth = 1
            let label = UILabel(frame: circleView.bounds)
            label.font = UIFont.systemFont(ofSize: 13.0)
            label.text = customAnnotation.label
            label.textColor = UIColor.white
            label.textAlignment = .center
            circleView.addSubview(label)
            self.addSubview(circleView)
            self.label = label
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.label?.text = nil
        
    }
}

extension UIColor {
    static func random() -> UIColor {
        let randomValue = drand48() * 0.5 + 0.5
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: randomValue
        )
    }
    
    static func gradeint(view:UIView) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        let color = UIColor.random()
        gradientLayer.colors = [color.cgColor, color.withAlphaComponent(0.1)]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 3.0)
        gradientLayer.frame = view.bounds
        return gradientLayer
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

class UserClusterAnnotationView: MKAnnotationView {
    static let preferredClusteringIdentifier = Bundle.main.bundleIdentifier! + ".UserClusterAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = UserClusterAnnotationView.preferredClusteringIdentifier
        collisionMode = .circle
        updateImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        didSet {
            clusteringIdentifier = UserClusterAnnotationView.preferredClusteringIdentifier
            updateImage()
        }
    }
    
    private func updateImage() {
        if let clusterAnnotation = annotation as? MKClusterAnnotation {
            self.image = image(count: clusterAnnotation.memberAnnotations.count)
        } else {
            self.image = image(count: 1)
        }
    }
    
    func image(count: Int) -> UIImage {
        let bounds = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { _ in
            
            
            // Fill full circle with tricycle color
            var color = UIColor.red
            
            if let customAnnotation = annotation as? CustomAnnotation {
                if count == 1 {
                    if let value = Double(customAnnotation.label ?? "7.5") {
                        color = setupMag(mag: value)
                    }
                    color.setFill()
                    UIBezierPath(ovalIn: bounds).fill()
                    
                    // Fill inner circle with white color
                    color.setFill()
                    
                    UIBezierPath(ovalIn: bounds.insetBy(dx: 1, dy: 1)).fill()
                    
                    // Finally draw count text vertically and horizontally centered
                    let attributes: [NSAttributedString.Key: Any] = [
                        .foregroundColor: UIColor.white,
                        .font: UIFont.boldSystemFont(ofSize: 13)
                    ]
                    let text = customAnnotation.label ?? ""
                    let size = text.size(withAttributes: attributes)
                    let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.midY - size.height / 2)
                    let rect = CGRect(origin: origin, size: size)
                    text.draw(in: rect, withAttributes: attributes)
                }
                
            }
            else
            {
                color.setFill()
                UIBezierPath(ovalIn: bounds).fill()
                
                // Fill inner circle with white color
                color.setFill()
                
                UIBezierPath(ovalIn: bounds.insetBy(dx: 1, dy: 1)).fill()
                
                // Finally draw count text vertically and horizontally centered
                let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.boldSystemFont(ofSize: 13)
                ]
                
                let text = "\(count)+"
                let size = text.size(withAttributes: attributes)
                let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.midY - size.height / 2)
                let rect = CGRect(origin: origin, size: size)
                text.draw(in: rect, withAttributes: attributes)
            }
            
        }
    }
    
    func setupMag(mag:Double) -> UIColor {
        if mag > 0 && mag < 2.5 {
            return UIColor(hexString: "A6BE80")
        }
        else if mag > 2.5 && mag < 3.5 {
            return UIColor(hexString: "99C933")
        }
        else if mag > 3.5 && mag < 4.5 {
            return UIColor(hexString: "F3B61A")
        }
        else if mag > 4.5 && mag < 5.5 {
            return UIColor(hexString: "FF5C00")
        }
        else if mag > 5.5 && mag < 6.5 {
            return UIColor(hexString: "FF271A")
        }
        else if mag > 6.5 && mag < 7.5 {
            return UIColor(hexString: "FF000F")
        }
        else if mag > 7.5 && mag < 8.5 {
            return UIColor(hexString: "FF006B")
        }
        else {
            return UIColor(hexString: "FF006B")
        }
        
    }
}
