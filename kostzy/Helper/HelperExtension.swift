//
//  HelperExtension.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 28/05/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import Foundation
import UIKit
/*
import SwiftyGif
 */

var associateObjectValue: Int = 0

public typealias AnimationCompletion = () -> Void
public typealias AnimationExecution = () -> Void

// MARK: - IBDesignable
@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

// MARK: - UIButton Extension
extension UIButton {
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0,y: 0.0,width: 1.0,height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func setBackgroundColor(color: UIColor, forUIControlState state: UIControl.State) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
    
}

// MARK: - UIView Extension
extension UIView: CAAnimationDelegate {
    
    /**
     Adds a vertical gradient layer with two **UIColors** to the **UIView**.
     - Parameter topColor: The top **UIColor**.
     - Parameter bottomColor: The bottom **UIColor**.
     */
    
    func addVerticalGradientLayer(topColor:UIColor, bottomColor:UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - IBInspectable
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
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    fileprivate var isAnimate: Bool {
        get {
            return objc_getAssociatedObject(self, &associateObjectValue) as? Bool ?? false
        }
        set {
            return objc_setAssociatedObject(self, &associateObjectValue, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @IBInspectable var shimmerAnimation: Bool {
        get {
            return isAnimate
        }
        set {
            self.isAnimate = newValue
        }
    }
    
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
    
    //Circle Fill Animation
    private func getDiagonal() -> CGFloat {
        let origin = self.frame.origin
        let opposite = CGPoint(x: origin.x + self.frame.width,
                               y: origin.y + self.frame.height)
        
        let distanceX = origin.x - opposite.x
        let distanceY = origin.y - opposite.y
        let diagonal = sqrt(pow(distanceX, 2) + pow(distanceY, 2))
        return diagonal
    }
    
    /* FILL BACKGROUND */
    func fillBackgroundFrom(point: CGPoint, with color: UIColor, in time: CFTimeInterval = 1.0) {
        let initialDiameter: CGFloat = 0.5
        let diagonal = getDiagonal()
        let fullViewValue = (diagonal / initialDiameter) * 2
        
        // Create layer
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: initialDiameter,
                             height: initialDiameter)
        layer.position = point
        layer.cornerRadius = initialDiameter / 2
        layer.backgroundColor = color.cgColor
        layer.name = "color"
        
        // Create animation
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = fullViewValue
        animation.duration = time
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        animation.setValue("fill", forKey: "name")
        
        // Add animation to layer and layer to view
        layer.add(animation, forKey: "fillAnimation")
        self.layer.insertSublayer(layer, at: 0)
        //self.layer.addSublayer(layer)
        self.layer.masksToBounds = true
    }
    
    /* EMPTY BACKGROUND */
    func emptyBackgroundTo(point: CGPoint, with color: UIColor, in time: CFTimeInterval = 1.0) {
        guard let subLayers = self.layer.sublayers else {
            return
        }
        
        for subLayer in subLayers {
            if subLayer.name == "color" {
                guard let presentationLayer = subLayer.presentation(),
                let value = presentationLayer.value(forKeyPath: "transform.scale") else {
                    return
                }
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.fromValue = value
                animation.toValue = 1.0
                animation.duration = time
                animation.delegate = self
                animation.setValue("empty", forKey: "name")
                subLayer.add(animation, forKey: "fillAnimation")
            }
        }
    }
}

// MARK: - Struct: Color Global Variables
struct GlobalVariables {
    static let blue = UIColor.rbg(r: 129, g: 144, b: 255)
    static let purple = UIColor.rbg(r: 161, g: 114, b: 255)
}

// MARK: - Extensions
extension UIView {
    func pinEdgesToSuperView() {
        guard let superView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
    
    func setIsHidden(_ hidden: Bool, animated: Bool) {
        if animated {
            if self.isHidden && !hidden {
                self.alpha = 0.0
                self.isHidden = false
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = hidden ? 0.0 : 1.0
            }) { (complete) in
                self.isHidden = hidden
            }
        } else {
            self.isHidden = hidden
        }
    }
    
    func upperlined() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.3450980392, alpha: 0.6)
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0.26)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context!.setFillColor(color.cgColor)
        context!.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}

extension UIColor{
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
}

extension UITextField {
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.init(red: 133/255, green: 170/255, blue: 209/255, alpha: 0.61).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UITextView {
    func underlinedTextView() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.init(red: 133/255, green: 170/255, blue: 209/255, alpha: 0.61).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

extension String{
    var date : Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID")
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.date(from: self)
    }
}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFill else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

extension UIViewController {
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
    
    func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.backgroundColor = backgoundColor

            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.title = title
            
            //self.navigationController?.navigationBar.layer.cornerRadius = 20
            //self.navigationController?.navigationBar.clipsToBounds = true
            //navigationController?.navigationBar.layer.masksToBounds = true
            //self.navigationController?.navigationBar.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]

        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = backgoundColor
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.isTranslucent = true
            navigationItem.title = title
        }
    }
    
    func roundedNavigationBar(title: String) {
        // 1. Enable prefersLargeTitles and title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = title

        //3. Change default navbar to blank UI
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.4093762636, green: 0.408560425, blue: 0.8285056949, alpha: 1)

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .white

        //4. Add shadow and cirner radius to navbar
        let offset : CGFloat = (self.navigationController?.view.safeAreaInsets.top ?? 20)

        let shadowView = UIView(frame: CGRect(x: 0, y: -offset,
                                           width: (self.navigationController?.navigationBar.bounds.width)!,
                                           height: (self.navigationController?.navigationBar.bounds.height)! + offset))
        shadowView.backgroundColor = .clear
        self.navigationController?.navigationBar.insertSubview(shadowView, at: 1)

        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: shadowView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight , .topLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath

        shadowLayer.fillColor = #colorLiteral(red: 0.4093762636, green: 0.408560425, blue: 0.8285056949, alpha: 1)

        shadowLayer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 0.25
        shadowLayer.shadowRadius = 5

        shadowView.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }
}

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
}

private extension DateComponents {
  func scaled(by: Int) -> DateComponents {
    let s: (Int?)->Int? = { $0.map { $0 * by } }
    return DateComponents(calendar: calendar,
                          timeZone: timeZone,
                          era: s(era),
                          year: s(year), month: s(month), day: s(day),
                          hour: s(hour), minute: s(minute), second: s(second), nanosecond: s(nanosecond),
                          weekday: s(weekday), weekdayOrdinal: s(weekdayOrdinal), quarter: s(quarter),
                          weekOfMonth: s(weekOfMonth), weekOfYear: s(weekOfYear), yearForWeekOfYear: s(yearForWeekOfYear))
    }
}

extension Calendar {
  func makeIterator(components: DateComponents, from date: Date, until: Date?) -> Calendar.DateComponentsIterator {
    return DateComponentsIterator(calendar: self, startDate: date, cutoff: until, components: components, count: 0)
  }

  func makeIterator(every component: Component, stride: Int = 1, from date: Date, until: Date?) -> Calendar.DateComponentsIterator {
    var components = DateComponents(); components.setValue(stride, for: component)
    return makeIterator(components: components, from: date, until: until)
  }

  struct DateComponentsIterator: IteratorProtocol {
    let calendar: Calendar
    let startDate: Date
    let cutoff: Date?
    let components: DateComponents
    var count: Optional<Int> = 0

    mutating func next() -> Date? {
      guard let count = self.count else { return nil } // Ended.
      guard let nextDate = calendar.date(byAdding: components.scaled(by: count), to: startDate) else {
        self.count = nil; return nil
      }
      if let cutoff = self.cutoff, nextDate > cutoff {
        self.count = nil; return nil
      }
      self.count = count + 1
      return nextDate
    }
  }
}

extension SplashView {
    
    //---------------------------------
    //--- The function called to start the animation, Entry point of extention.
    //---------------------------------
    public func startAnimation(_ completion: AnimationCompletion? = nil)
    {
        switch animationType{
        case .twitter:
            playTwitterAnimation(completion)
            
        case .heartBeat:
            playHeartBeatAnimation(completion)
        }
    }
    
    
    //---------------------------------
    //--- Makes the twitter animation overlay.
    //---------------------------------
    public func playTwitterAnimation(_ completion: AnimationCompletion? = nil)
    {
        
        if let imageView = self.imageView {
            
            //Define the shink and grow duration based on the duration parameter
            let shrinkDuration: TimeInterval = duration * 0.01
            
            //Plays the shrink animation
            UIView.animate(withDuration: shrinkDuration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIView.AnimationOptions(), animations: {
                //Shrinks the image
                let scaleTransform: CGAffineTransform = CGAffineTransform(scaleX: 1,y: 1)
                imageView.transform = scaleTransform
                
                //When animation completes, grow the image
            }, completion: { finished in
                
                self.playZoomOutAnimation(completion)
            })
        }
    }
    
    //---------------------------------
    //--- Twitter Zoom out animation performs here.
    //--- Remove the view after animation
    //---------------------------------
    public func playZoomOutAnimation(_ completion: AnimationCompletion? = nil)
    {
        if let imageView =  imageView
        {
            let growDuration: TimeInterval =  duration * 0.3
            
            UIView.animate(withDuration: growDuration, animations:{
                
                imageView.transform = self.getZoomOutTranform()
                self.alpha = 0
                
                //When animation completes remote self from super view
            }, completion: { finished in
                
                self.removeFromSuperview()
                
                completion?()
            })
        }
    }
    
    //---------------------------------
    //--- Makes the heartbeat animation for icon.
    //---------------------------------
    public func playHeartBeatAnimation(_ completion: AnimationCompletion? = nil)
    {
        if let imageView = self.imageView {
            
            let popForce = 1.5 // How much high can go.
            
            animateLayer({
                let animation = CAKeyframeAnimation(keyPath: "transform.scale")
                animation.values = [0, 0.1 * popForce, 0.015 * popForce, 0.2 * popForce, 0]
                animation.keyTimes = [0, 0.25, 0.50, 0.75, 1]
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                animation.duration = CFTimeInterval(self.duration/2)
                animation.isAdditive = true
                animation.repeatCount = Float(minimumBeats > 0 ? minimumBeats : 1)
                animation.beginTime = CACurrentMediaTime() + CFTimeInterval(self.delay/2)
                imageView.layer.add(animation, forKey: "pop")
            }, completion: { [weak self] in
                if self?.heartAttack ?? true {
                    self?.playZoomOutAnimation(completion)
                } else {
                    self?.playHeartBeatAnimation(completion)
                }
            })
        }
    }
    
    
    //---------------------------------
    //--- stop the heart beat
    //--- Once the heart beat stops the Zoom out function called to perform the final animation
    //---------------------------------
    public func finishHeartBeatAnimation()
    {
        self.heartAttack = true
    }
    
    //---------------------------------
    //--- returns the default zoom out transform
    //---------------------------------
    fileprivate func getZoomOutTranform() -> CGAffineTransform
    {
        let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 20, y: 20)
        return zoomOutTranform
    }
    
    //---------------------------------
    //--- Animate layer continuosly to show as heart beat
    //---------------------------------
    fileprivate func animateLayer(_ animation: AnimationExecution, completion: AnimationCompletion? = nil) {
        
        CATransaction.begin()
        if let completion = completion {
            CATransaction.setCompletionBlock { completion() }
        }
        animation()
        CATransaction.commit()
    }

}

// MARK: - Classes
class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

class CircleView : UIView {
    var color = UIColor.blue {
        didSet {
            layer.backgroundColor = color.cgColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // Setup the view, by setting a mask and setting the initial color
    private func setup(){
        layer.mask = shape
        layer.backgroundColor = color.cgColor
    }

    // Change the path in case our view changes it's size
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = CGMutablePath()
        // add an elipse, or what ever path/shapes you want
        path.addEllipse(in: bounds)
        // Created an inverted path to use as a mask on the view's layer
        shape.path = UIBezierPath(cgPath: path).reversing().cgPath
    }
    // this is our shape
    private var shape = CAShapeLayer()
}

class IndicatorView: UIView {
    var color = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        UIBezierPath(ovalIn: rect).fill()
    }
}

/*
class LogoAnimationView: UIView {
    let logoGifImageView: UIImageView = {
        guard let gifImage = try? UIImage(gifName: "Awaro-splash-(white)-no-loop.gif") else {
            return UIImageView()
        }
        return UIImageView(gifImage: gifImage, loopCount: 1)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = #colorLiteral(red: 0.4093762636, green: 0.408560425, blue: 0.8285056949, alpha: 1)
        addSubview(logoGifImageView)
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoGifImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        logoGifImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
}
*/

class SplashView: UIView {

    
    //---------------------------------
    //--- pass the icon image, to view and to animate -- both are same image
    //---------------------------------
    open var iconImage: UIImage? {
        
        didSet{
            if let iconImage = self.iconImage{
                imageView?.image = iconImage
            }
        }
        
    }
    
    //---------------------------------
    //--- pass the icon color, if required. By default its white, like twitter
    //---------------------------------
    open var iconColor: UIColor = UIColor.white{
        
        didSet{
            
            imageView?.tintColor = iconColor
        }
        
    }
    
    //---------------------------------
    //--- Custom icon color if required to pass with rendering
    //--- True - if using background color
    //--- false - if using background image
    //---------------------------------
    open var useCustomIconColor: Bool = false{
        
        didSet{
            
            if(useCustomIconColor == true){
                
                if let iconImage = self.iconImage {
                    imageView?.image = iconImage.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                }
            }
            else{
                
                if let iconImage = self.iconImage {
                    imageView?.image = iconImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                }
            }
        }
    }
    
    //---------------------------------
    //--- pass the icon size,
    //--- In case using launch screen with the Imageview, the size should match the icon size of the imageview.
    //--- If don't want to see the heartbeat till API call, then Image view should be visible there in splash screen too.
    //---------------------------------
    
    open var iconInitialSize: CGSize = CGSize(width: 60, height: 60) {
        
        didSet{
            
            imageView?.frame = CGRect(x: 0, y: 0, width: iconInitialSize.width, height: iconInitialSize.height)
        }
    }
    
    
    //---------------------------------
    //--- If required to show image in spite of background color
    //---------------------------------
    open var backgroundImageView: UIImageView?
    
    //---------------------------------
    //--- Image view used to hold the icon
    //---------------------------------
    open var imageView: UIImageView?
    
    //---------------------------------
    //--- Default Twitter, as per requirement change to heartbeat
    //---------------------------------
    open var animationType: AnimationType = AnimationType.twitter
    
    //---------------------------------
    //--- Duration of animation, default is 1.5, In case of Heartbeat-pass 3
    //---------------------------------
    open var duration: Double = 1.5
    
    //---------------------------------
    //--- delay of the animation to zoom in and out
    //---------------------------------
    open var delay: Double = 0.5
    
    //---------------------------------
    //--- Default - False - will continuos beat, True - stop the heartbeat
    //---------------------------------
    open var heartAttack: Bool = false
    
    //---------------------------------
    //--- Repeat counter of heartbeat, Default - 1
    //---------------------------------
    open var minimumBeats: Int = 1
    
    //---------------------------------
    //--- Default constructor of the class
    //--- iconImage:       The Icon image to show the animation
    //--- iconInitialSize: The initial size of the icon image
    //--- backgroundColor: The background color of the image
    //--- returns: SplashView Object
    //---------------------------------
    public init(iconImage: UIImage, iconInitialSize:CGSize, backgroundColor: UIColor)
    {
        //Sets the initial values of the image view and icon view
        self.imageView = UIImageView()
        self.iconImage = iconImage
        self.iconInitialSize = iconInitialSize
        //Inits the view to the size of the screen
        super.init(frame: (UIScreen.main.bounds))
        
        imageView?.image = iconImage
        imageView?.tintColor = iconColor
        //Set the initial size and position
        imageView?.frame = CGRect(x: 0, y: 0, width: iconInitialSize.width, height: iconInitialSize.height)
        //Sets the content mode and set it to be centered
        imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        imageView?.center = self.center
        
        //Adds the icon to the view
        self.addSubview(imageView!)
        
        //Sets the background color
        self.backgroundColor = backgroundColor
        
    }
    
    //---------------------------------
    //--- Default constructor of the class
    //--- iconImage:       The Icon image to show the animation
    //--- iconInitialSize: The initial size of the icon image
    //--- backgroundImage: The background image to show behined icon
    //--- returns: SplashView Object
    //---------------------------------
    public init(iconImage: UIImage, iconInitialSize:CGSize, backgroundImage: UIImage)
    {
        //Sets the initial values of the image view and icon view
        self.imageView = UIImageView()
        self.iconImage = iconImage
        self.iconInitialSize = iconInitialSize
        //Inits the view to the size of the screen
        super.init(frame: (UIScreen.main.bounds))
        
        imageView?.image = iconImage
        imageView?.tintColor = iconColor
        //Set the initial size and position
        imageView?.frame = CGRect(x: 0, y: 0, width: iconInitialSize.width, height: iconInitialSize.height)
        //Sets the content mode and set it to be centered
        imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        imageView?.center = self.center
        
        //Sets the background image
        self.backgroundImageView = UIImageView()
        backgroundImageView?.image = backgroundImage
        backgroundImageView?.frame = UIScreen.main.bounds
        backgroundImageView?.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.addSubview(backgroundImageView!)
        
        //Adds the icon to the view
        self.addSubview(imageView!)
        
    }
    
    //---------------------------------
    //--- Decoder and coder haven't defined.
    //---------------------------------
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) haven't implemented")
    }
}

// MARK: - Enums
enum ViewControllerType {
    case welcome
    case home
}

enum PhotoSource {
    case library
    case camera
}

enum ShowExtraView {
    case contacts
    case profile
    case preview
    case map
}

enum MessageType {
    case photo
    case text
    case location
}

enum MessageOwner {
    case sender
    case receiver
}

enum ColorCompatibility {
    static var myOlderiOSCompatibleColorName: UIColor {
        if UIViewController().isDarkMode {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else {
            //return UIColor(hexString: "#F3F3F3", alpha: 0.85)
            return UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        }
    }
}

enum ActionDescriptor {
    case read, unread, more, flag, trash, done, undone
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        case .read: return "Read"
        case .unread: return "Unread"
        case .more: return "More"
        case .flag: return "Flag"
        case .trash: return "Delete"
        case .done: return "Done"
        case .undone: return "Undone"
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        guard displayMode != .titleOnly else { return nil }
        
        let name: String
        switch self {
        case .read: name = "Read"
        case .unread: name = "Unread"
        case .more: name = "More"
        case .flag: name = "Flag"
        case .trash: name = "Delete"
        case .done: name = "Done"
        case .undone: name = "Undone"
        }
        
    #if canImport(Combine)
        if #available(iOS 13.0, *) {
            let name: String
            switch self {
            case .read: name = "envelope.open.fill"
            case .unread: name = "envelope.badge.fill"
            case .more: name = "ellipsis.circle.fill"
            case .flag: name = "flag.fill"
            case .trash: name = "trash.fill"
            case .done: name = "checkmark.circle.fill"
            case .undone: name = "checkmark.circle"
            }
            
            if style == .backgroundColor {
                let config = UIImage.SymbolConfiguration(pointSize: 23.0, weight: .regular)
                return UIImage(systemName: name, withConfiguration: config)
            } else {
                let config = UIImage.SymbolConfiguration(pointSize: 22.0, weight: .regular)
                let image = UIImage(systemName: name, withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysTemplate)
                return circularIcon(with: color(forStyle: style), size: CGSize(width: 50, height: 50), icon: image)
            }
        } else {
            return UIImage(named: style == .backgroundColor ? name : name + "-circle")
        }
    #else
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    #endif
    }
    
    func color(forStyle style: ButtonStyle) -> UIColor {
    #if canImport(Combine)
        switch self {
        case .read, .unread, .done, .undone: return UIColor.systemBlue
        case .more:
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    return UIColor.systemGray
                }
                return style == .backgroundColor ? UIColor.systemGray3 : UIColor.systemGray2
            } else {
                return #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
            }
        case .flag: return UIColor.systemOrange
        case .trash: return UIColor.systemRed
        }
    #else
        switch self {
        case .read, .unread, .done, .undone: return #colorLiteral(red: 0, green: 0.4577052593, blue: 1, alpha: 1)
        case .more: return #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
        case .flag: return #colorLiteral(red: 1, green: 0.5803921569, blue: 0, alpha: 1)
        case .trash: return #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        }
    #endif
    }
    
    func circularIcon(with color: UIColor, size: CGSize, icon: UIImage? = nil) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        UIBezierPath(ovalIn: rect).addClip()

        color.setFill()
        UIRectFill(rect)

        if let icon = icon {
            let iconRect = CGRect(x: (rect.size.width - icon.size.width) / 2,
                                  y: (rect.size.height - icon.size.height) / 2,
                                  width: icon.size.width,
                                  height: icon.size.height)
            icon.draw(in: iconRect, blendMode: .normal, alpha: 1.0)
        }

        defer { UIGraphicsEndImageContext() }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}

public enum AnimationType: String{
    case twitter
    case heartBeat
}

// MARK: - Protocols
protocol RoundedCornerNavigationBar {
    func addRoundedCorner(OnNavigationBar navigationBar: UINavigationBar, cornerRadius: CGFloat)
}

extension RoundedCornerNavigationBar where Self: UIViewController{
    
    func addRoundedCorner(OnNavigationBar navigationBar: UINavigationBar, cornerRadius: CGFloat){
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.backgroundColor = .white
        
        let customView = UIView(frame: CGRect(x: 0, y: navigationBar.bounds.maxY, width: navigationBar.bounds.width, height: cornerRadius))
        customView.backgroundColor = .clear
        navigationBar.insertSubview(customView, at: 1)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: customView.bounds, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        shapeLayer.shadowColor = UIColor.lightGray.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 4.0)
        shapeLayer.shadowOpacity = 0.8
        shapeLayer.shadowRadius = 2
        shapeLayer.fillColor = UIColor.white.cgColor
        customView.layer.insertSublayer(shapeLayer, at: 0)
    }
}

extension UIColor {
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
