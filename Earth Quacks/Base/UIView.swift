//
//  UIView.swift
//  Abbel-Cars
//
//  Created by a on 25/08/2020.
//  Copyright © 2020 Mian Faizan Nasir. All rights reserved.
//

import UIKit


extension UIView {
    
    //clears background color of UISearchBar
    public func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let wrapped = view as? T, wrapped != self{
                all.append(wrapped)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
    
    func addGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func pinEdgesToSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
    
    func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        layer.add(animation, forKey: "borderColor")
        layer.borderColor = toColor.cgColor
      }
//    func activityStartAnimating() {
//        LoaderAnimation.shared.playAnimation()
//    }
//    func activityStopAnimating() {
//        LoaderAnimation.shared.stopAnimation()
//    }
}



enum VerticalLocation: String {
    case bottom
    case top
}

enum UIViewCorners: String {
    case bottomLeft
    case topLeft
    case topRight
    case bottomRight
    case all
}

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension String {
    var localized: String {
        get { return NSLocalizedString(self, comment: "") }
    }
}

extension UIView {
    
    @IBInspectable
    var isCirculer: Bool {
        
        get {
            return layer.cornerRadius == min(self.frame.width, self.frame.height) / CGFloat(2.0) ? true : false
        }
        
        set {
            
            if newValue {
                layer.cornerRadius = self.frame.height/2
                self.clipsToBounds = true
                
            } else {
                layer.cornerRadius = 0.0
                self.clipsToBounds = false
            }
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        
        get {
            
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        
        set {
            
            if let color = newValue {
                layer.borderColor = color.cgColor
                
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        
        get {
            return layer.shadowRadius
        }
        
        set {
            layer.shadowRadius = newValue
        }
    }
    
    
    @IBInspectable
    var shadowOpacity: Float {
        
        get {
            return layer.shadowOpacity
        }
        
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        
        get {
            return layer.shadowOffset
        }
        
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        
        get {
            
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        
        set {
            
            if let color = newValue {
                layer.shadowColor = color.cgColor
                
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0, cornerRadius: CGFloat = 1.0, addBorder: Bool = false, borderColor: UIColor = UIColor.lightText, borderWidth: CGFloat = 1.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.cornerRadius = cornerRadius
        if addBorder {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = borderWidth
        }
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        
        switch location {
            
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
            
        case .top:
            addShadow(offset: CGSize(width: 0, height: -1.5), color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
    
    func roundCorner(uiViewCorner: UIViewCorners, radius: CGFloat = 5.0) {
        
        switch uiViewCorner {
            
        case .topLeft:
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.topLeft], cornerRadii: CGSize.init(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
            
        case .topRight:
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.topRight], cornerRadii: CGSize.init(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
            
        case .bottomLeft:
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.bottomLeft], cornerRadii: CGSize.init(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
            
        case .bottomRight:
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.bottomRight], cornerRadii: CGSize.init(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        case .all:
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.bottomRight,.topRight,.topLeft,.bottomLeft], cornerRadii: CGSize.init(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }

    }
    
    func roundCorners(uiViewCorners: VerticalLocation, radius: CGFloat = 5.0) {
        
        switch uiViewCorners {
            
        case .top:
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize.init(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
            self.layoutIfNeeded()
            
        case .bottom:
            let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:[.bottomLeft, .bottomRight], cornerRadii: CGSize.init(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
            self.layoutIfNeeded()
        }
    }
    
    
    func roundCornersTopView(_ radius: CGFloat)
    {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        layer.masksToBounds = true
    }
    
    func addRoundCorners(cornerRadius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }
}
@IBDesignable class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.clear
    @IBInspectable var secondColor: UIColor = UIColor.darkGray.withAlphaComponent(0.7)
    
    @IBInspectable var vertical: Bool = true
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()
    
    //MARK: -
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    //MARK: -
    
    func applyGradient() {
        backgroundColor = .clear
        updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }
    
    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }
    
    func updateGradientDirection() {
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
}

@IBDesignable class ThreeColorsGradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.red
    @IBInspectable var secondColor: UIColor = UIColor.green
    @IBInspectable var thirdColor: UIColor = UIColor.blue
    
    @IBInspectable var vertical: Bool = true {
        didSet {
            updateGradientDirection()
        }
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()
    
    //MARK: -
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    //MARK: -
    
    func applyGradient() {
        updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }
    
    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }
    
    func updateGradientDirection() {
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
}

extension UIView {
    
    // MARK: - Methods
    func xibSetup() {
        let view = loadFromNib()
        addSubview(view)
        stretch(view: view)
    }
    
    func loadFromNib<T: UIView>() -> T {
        let selfType = type(of: self)
        let bundle = Bundle(for: selfType)
        let nibName = String(describing: selfType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            fatalError("Error loading nib with name \(nibName).")
        }
        return view
    }
    
    func stretch(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
}
