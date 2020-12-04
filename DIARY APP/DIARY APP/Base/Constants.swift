//  Constants.swift
//  DIARY APP
//
//  Created by Bhavik Darji on 03/12/20.
//

import Foundation
import SystemConfiguration
import Foundation
import UIKit
import ProgressHUD


struct Constants {
    
    // Server URL
    static let SERVER_API                       = "https://private-ba0842-gary23.apiary-mock.com/"
    static let kUserDefaults                    = UserDefaults.standard
    static let kSharedAppDelegate               = (UIApplication.shared.delegate as? AppDelegate)
    static let kSharedAppSceneDelegate          = (UIApplication.shared.delegate as? SceneDelegate)
    static let appVersion                       = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let kDateToday                       = Date()
    static let deviceType                      = "ios"

    // Server Api's
    static let notes                                     = "notes"

    
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
extension UIImageView {
    @IBInspectable
    var changeColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!);
            return color
        }
        set {
            let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
            self.image = templateImage
            self.tintColor = newValue
        }
    }
}

class TableViewHelper {

    class func EmptyMessage(message:String, viewController:UITableView)
    {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: screenWidth, height: screenHeight))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        viewController.backgroundView = messageLabel;
        viewController.separatorStyle = .none;
    }
}

public func ViewAddShadow(shadowView:UIView)  {
    shadowView.backgroundColor = UIColor.white
    let shadowSize : CGFloat = 5.0
    let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                               y: -shadowSize / 2,
                                               width: shadowView.frame.size.width + shadowSize,
                                               height: shadowView.frame.size.height + shadowSize))
    shadowView.layer.masksToBounds = false
    shadowView.layer.shadowColor = UIColor.lightGray.cgColor
    shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 1)
    shadowView.layer.shadowOpacity = 0.1
    shadowView.layer.shadowPath = shadowPath.cgPath
    shadowView.layer.shadowRadius = 5

}

public var StoryBoard: UIStoryboard
{
    return UIStoryboard(name: "Main", bundle:nil)
}

extension String
{
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    func isValidMobile() -> Bool {
        let PHONE_REGEX = "[0-9]{10}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    func isBlank() -> Bool{
        let strTrimmed = self.trim()//get trimmed string
        if(strTrimmed.count == 0)//check textfield is nil or not ,if nil then return false
        {
            return true
        }
        return false
    }
    func trim() -> String{
        let strTrimmed = (NSString(string:self)).trimmingCharacters(in: CharacterSet.whitespaces)
        return strTrimmed
    }
    
    func isValidEmailID() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func trimWhiteSpace() -> String {
        let string = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return string
    }

}
// for emoji
public func encodeEmojiSring(_ s: String) -> String {
    let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
    return String(data: data, encoding: .utf8)!
}
public func decodeEmojiSring(_ s: String) -> String? {
    let data = s.data(using: .utf8)!
    return String(data: data, encoding: .nonLossyASCII)
}

// Screen width.
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
        
    }
    
}
extension NSAttributedString {
    
    func replacing(placeholder:String, with valueString:String) -> NSAttributedString {
        
        if let range = self.string.range(of:placeholder) {
            let nsRange = NSRange(range,in:valueString)
            let mutableText = NSMutableAttributedString(attributedString: self)
            mutableText.replaceCharacters(in: nsRange, with: valueString)
            return mutableText as NSAttributedString
        }
        return self
    }
    
}

public class API {
    
    class func api_callMethodPostNew(_ apiName: String, withparams parameters: String, withloder indicator: Bool,withController view: UIViewController, sucess success: @escaping (_ response: Any) -> Void, failure: @escaping (_ error: Error?) -> Void)
    {
        if Reachability.isConnectedToNetwork() == true
        {
            if indicator
            {
                ProgressHUD .show(nil, interaction: false)
            }

            let jsonRequest: NSMutableURLRequest = NSMutableURLRequest()
            jsonRequest.url = URL(string: "\(Constants.SERVER_API)\(Constants.notes)")!
            jsonRequest.httpMethod = "GET"
            jsonRequest.timeoutInterval = 180
                    
            let task = URLSession.shared.dataTask(with: jsonRequest as URLRequest) { data, response, error in
                if response != nil {
                    ProgressHUD .dismiss()
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                       // print(jsonResult)
                        OperationQueue.main.addOperation {
                            success(jsonResult as Any )
                        }

                    } catch let error as NSError {
                        print(error.localizedDescription)
                        OperationQueue.main.addOperation {
                            failure(error)
                        }
                    }
                } else {
                    OperationQueue.main.addOperation {
                        failure(error)
                    }
                    ProgressHUD .dismiss()
                }
            }
            task.resume()

        }
        else
        {
            OperationQueue.main.addOperation {
                failure(nil)
            }

            ProgressHUD .dismiss()
            let alert = UIAlertController(title: NSLocalizedString("Network error", comment: ""), message: NSLocalizedString("Unable to contact the server.", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            view.present(alert, animated: true, completion: nil)

        }
    }
    
    
    
}


extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
}
