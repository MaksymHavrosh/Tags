//
//  BaseExtension.swift
//  Tags
//
//  Created by MG on 14.07.2021.
//

import UIKit

enum TagsGlobalViews: Int {
    case inBlockScreen = 24102017
    case inBlockCustomView = 22022018
    case blockScreen = 26102017
    case offInternet = 20102017
    case onInternet = 19102017
    case informView = 18102017
    case loadingIndicator = 26102018
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}

// MARK: - UIStoryboard

extension UIStoryboard {
    enum Storyboard {
        case tabBarViewController
        
        var title: String {
            return String(describing: self).firstUppercased
        }
    }
    
    convenience init(storyboard: Storyboard) {
        self.init(name: storyboard.title, bundle: nil)
    }
    
    func instantiateViewController<T: UIViewController>(_ type: T.Type) -> T {
        let id = NSStringFromClass(T.self).components(separatedBy: ".").last!
        return self.instantiateViewController(withIdentifier: id) as! T
    }
}

// MARK: - UIViewController

extension UIViewController {
    static var fromStoryboard: Self {
        let selfName = NSStringFromClass(self).components(separatedBy: ".").last!
        let storyboard = UIStoryboard(name: selfName, bundle: nil)
        let customViewController = storyboard.instantiateViewController(withIdentifier: selfName) as! Self
        
        return customViewController
    }
    
    class func instance(_ storyboard: UIStoryboard.Storyboard) -> Self {
        
        let storyboard = UIStoryboard(storyboard: storyboard)
        let viewController = storyboard.instantiateViewController(self)
        
        return viewController
    }
    
    class func fromNib<T: UIViewController>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func showLoginAlert(title: String?, message: String?, customActions: [UIAlertAction] = []) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            if customActions.isEmpty {
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default))
            } else {
                for action in customActions {
                    alert.addAction(action)
                }
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func add(_ child: UIViewController, superView: UIView? = nil) {
        addChild(child)
        
        if let customSuperView = superView {
            customSuperView.addSubview(child.view)
            customSuperView.constrainToEdges(child.view)
        } else {
            view.addSubview(child.view)
            view.constrainToEdges(child.view)
        }
        
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func showErrorAlert(message: String) {
        self.showAlert(title: NSLocalizedString("Error", comment: ""), message: message, completion: {})
    }
    
    func showInDevelopmentAlert(message: String) {
        self.showAlert(title: "In development", message: message, completion: {})
    }
    
    func showErrorAlert(message: String, completion: @escaping () -> Void) {
        self.showAlert(title: NSLocalizedString("Error", comment: ""), message: message, completion: completion)
    }
    
    func showAlert(title: String?, message: String?, customActions: [UIAlertAction] = [], completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            if customActions.isEmpty {
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default) { _ in completion() })
            } else {
                for action in customActions {
                    alert.addAction(action)
                }
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func addSwipeAction(action: Selector?, direction: UISwipeGestureRecognizer.Direction) {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: action)
        swipeRecognizer.direction = direction
        self.view.addGestureRecognizer(swipeRecognizer)
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    enum Constraints {
        case top
        case bottom
        case left
        case right
    }
    
    func addSwipeAction(action: Selector?, direction: UISwipeGestureRecognizer.Direction) {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: action)
        swipeRecognizer.direction = direction
        self.addGestureRecognizer(swipeRecognizer)
    }
    
    @discardableResult
    func getConstrainToEdges(_ subview: UIView, top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) -> [Constraints: NSLayoutConstraint] {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: top)
        
        let bottomConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: bottom)
        
        let leadingConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: leading)
        
        let trailingConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: trailing)
        
        addConstraints([
            topConstraint,
            bottomConstraint,
            leadingConstraint,
            trailingConstraint])
        
        return [.top: topConstraint, .bottom: bottomConstraint,
                .left: leadingConstraint, .right: trailingConstraint]
    }
    
    func addShadow(to edges: [UIRectEdge], radius: CGFloat, color: UIColor? = nil) {
        
        let shadowColor = color ?? UIColor.init(displayP3Red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.2)
        
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        for edge in edges {
            switch edge {
            case UIRectEdge.top:
                let offset: CGFloat = self.layer.shadowOffset.height > 0 ? 0 : -1
                self.layer.shadowOffset.height = offset
                
            case UIRectEdge.bottom:
                let offset: CGFloat = self.layer.shadowOffset.height < 0 ? 0 : 1
                self.layer.shadowOffset.height = offset
                
            case UIRectEdge.left:
                let offset: CGFloat = self.layer.shadowOffset.width > 0 ? 0 : -1
                self.layer.shadowOffset.width = offset
                
            case UIRectEdge.right:
                let offset: CGFloat = self.layer.shadowOffset.width < 0 ? 0 : 1
                self.layer.shadowOffset.width = offset
                
            default: break
            }
        }
    }
    
    // Simple shadow
    func viewShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.16
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }
    
    class func fromNib<T: UIView>() -> T {
        return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! T
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    func constrainToEdges(_ subview: UIView, top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let topContraint = NSLayoutConstraint(
            item: subview,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: top)
        
        let bottomConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: bottom)
        
        let leadingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: leading)
        
        let trailingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: trailing)
        
        addConstraints([
            topContraint,
            bottomConstraint,
            leadingContraint,
            trailingContraint])
    }
    
    func viewCorner(_ radius: CGFloat? = nil) {
        layer.cornerRadius = radius ?? self.frame.height / 2
        layer.masksToBounds = true
    }
    
    func viewCornerForSide(_ roundingCorners: UIRectCorner, radius: CGFloat) {
        
        if #available(iOS 11.0, *) {
            clipsToBounds = false
            layer.cornerRadius = radius
            layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        } else {
            let rectShape = CAShapeLayer()
            rectShape.bounds = frame
            rectShape.position = center
            rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: 0, height: 0)).cgPath
            layer.mask = rectShape
        }
    }
    
    func viewBorder(color: UIColor, width: CGFloat = 1.0) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func inBlockCustomViewStart(flag: Bool) {
        
        DispatchQueue.main.async {
            
            let tag = TagsGlobalViews.inBlockCustomView.rawValue
            
            for subview in self.subviews where subview.tag == tag {
                subview.removeFromSuperview()
            }
            
            if !flag {
                return
            }
            
            let heightContainer: CGFloat = 80.0
            
            let container = UIView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            container.tag = tag
            
            container.layer.cornerRadius = 10
            container.clipsToBounds = true
            container.backgroundColor = UIColor.clear
            
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: container.frame.width / 2, y: container.frame.height / 2, width: heightContainer / 2, height: heightContainer / 2))
            
            loadingIndicator.center = container.center
            
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.large
            loadingIndicator.color = UIColor.green
            
            let transform: CGAffineTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            loadingIndicator.transform = transform
            loadingIndicator.startAnimating()
            
            container.addSubview(loadingIndicator)
            
            self.addSubview(container)
        }
    }
}

extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

extension NSObject {
    func safeRemoveObserver(_ observer: NSObject, keyPath: String, context: inout Int) {
        let result = checkIfAlreadyAdded(keyPath: keyPath, context: &context)
        
        if result {
            removeObserver(observer, forKeyPath: keyPath, context: &context)
        }
    }
    
    fileprivate func address(_ pointer: UnsafeRawPointer) -> Int {
        return Int(bitPattern: pointer)
    }
    
    fileprivate func checkIfAlreadyAdded(keyPath: String, context: inout Int) -> Bool {
        
        guard self.observationInfo != nil else { return false }
        
        let info = Unmanaged<AnyObject>
            .fromOpaque(self.observationInfo!)
            .takeUnretainedValue()
        
        let contextStr = NSString(format: "%p", address(&context))
        
        let infoStr = info.description ?? ""
        
        let regex = NSRegularExpression("\(keyPath).*[a-z].*\(contextStr)")
        let result = regex.matches(infoStr)
        
        return result
    }
}

extension UITableView {
    func reloadTableRows(isAnimate: Bool, path: [IndexPath]) {
        
        if isAnimate {
            self.reloadRows(at: path, with: .fade)
        } else {
            self.reloadRows(at: path, with: .none)
        }
    }
    
    func reloadTable(isAnimate: Bool, completion: ((Bool) -> Void)? = nil) {
        if isAnimate {
            UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.reloadData()
            }, completion: completion)
        } else {
            self.reloadData()
        }
    }
    
    func hasRowAtIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    func dequeueCell<T: UITableViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as! T
    }
    
    func registerCell<T: UITableViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: T.identifier, bundle: nil), forCellReuseIdentifier: T.identifier)
    }
}

extension UICollectionView {
    
    func reloadCollection(isAnimate: Bool) {
        if isAnimate {
            UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.reloadData()
            }, completion: nil)
        } else {
            self.reloadData()
        }
    }
    
    func dequeueCell<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as! T
    }
    
    func registerCell<T: UICollectionViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: cell.identifier, bundle: nil), forCellWithReuseIdentifier: cell.identifier)
    }
    
    func dequeueHeader<T: UICollectionReusableView>(_ header: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: header.identifier, for: indexPath) as! T
    }
    
    func dequeueFooter<T: UICollectionReusableView>(_ header: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: header.identifier, for: indexPath) as! T
    }
    
    func registerHeader<T: UICollectionReusableView>(_ view: T.Type) {
        return self.register(UINib(nibName: view.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: view.identifier)
    }
    
    func registerFooter<T: UICollectionReusableView>(_ view: T.Type) {
        self.register(UINib(nibName: view.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: view.identifier)
    }
}

extension UICollectionViewFlowLayout {

    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIColor {
    class func hex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        let cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.count == 6 {
            var rgbValue: UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        } else if cString.count == 8 {
            var rgbValue: UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return UIColor(
                red: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x000000FF) / 255.0,
                alpha: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            )
        } else {
            return UIColor.black
        }
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(for font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    var htmlAttributedString: NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let str = try? NSMutableAttributedString(
                data: data,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil) else { return nil }
        return str
    }
    
    func stringBefore(_ delimiter: Character, fromEnd: Bool = false) -> String {
        if let index = lastIndex(of: delimiter) {
            return String(prefix(upTo: index))
        } else {
            return ""
        }
    }
    
    func stringAfter(_ delimiter: Character, fromEnd: Bool = false) -> String {
        if let index = lastIndex(of: delimiter) {
            return String(suffix(from: index).dropFirst())
        } else {
            return ""
        }
    }
    
    func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
            str = nsString.substring(with:
                                        NSRange(
                                            location: 0,
                                            length: nsString.length > length ? length : nsString.length)
            )
        }
        return  str
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat = 1.0, width: CGFloat) {
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: width, height: thickness)
            
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
            
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            
        default: do {}
        }
        
        border.backgroundColor = color.cgColor
        addSublayer(border)
    }
}

extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
}

extension NSNotification.Name {
    static let reachable = NSNotification.Name("kNotificationReachable")
    static let openPlayer = NSNotification.Name("openPlayer")
    static let openSignIn = NSNotification.Name("kOpenSignIn")
    static let openSelectProfile = NSNotification.Name("kOpenSelectProfile")
    static let openPrivacyPolicy = NSNotification.Name("kOpenPrivacyPolicy")
}

extension UILabel {
    func setupAttributed(_ text: String?) {
        let attributedString = NSMutableAttributedString(string: text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        attributedText = attributedString
    }
}

extension UIDevice {
    var currentDeviceType: String {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return "ios_mobile"
        case .phone:
            return "ios_mobile"
        case .tv:
            return "apple_tv"
        default:
            return ""
        }
    }
}
