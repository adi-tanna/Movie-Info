//
//  Constant.swift
//  Bloved
//
//  Created by Aditya Tanna on 1/4/17.
//  Copyright © 2017 Go Proxima Inc. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}
struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}



extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }
}


//MARK: Show Alert
extension UIViewController {
    
    func showAlertWithErrorMsg(alertMsg: String) {
        let alert = UIAlertController(title: "", message: alertMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithErrorMsgAndPopUponOK(alertMsg: String) {
        
        let alert = UIAlertController(title: "Error", message: alertMsg, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { void in
            _ = self.navigationController?.popViewController(animated: true)
        });
        alert.addAction(action)
            
        self.present(alert, animated: true, completion: nil)
    }
    
    
    class func loadStoryboard(storyboardName: String, storyboardId: String) -> Self
    {
        return instantiateFromStoryboardHelper(storyboardName: storyboardName, storyboardId: storyboardId)
    }
    
    private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T
    {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        return controller
    }
}

extension String {
  
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height + 20
    }
   
    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width + 20
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        if let cachedVersion = getAppDelegate().cache.object(forKey: urlString as AnyObject) as? UIImage {
            
            let image = cachedVersion
            self.image = image
        
        } else {
            URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error ?? "Error")
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    getAppDelegate().cache.setObject(image!, forKey: urlString as AnyObject)
                    
                    self.image = image
                })
            }).resume()
        }
    }
}

//MARK: Global App Delegate
func getAppDelegate()  -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

//MARK: Common Web Service call & Show & Hide Activity Indicator with message
func callWebService(_ url: String, parameters: [String: AnyObject]?, methodHttp: HTTPMethod , completion: @escaping (_ result: AnyObject) -> Void, failure: @escaping (_ result: AnyObject) -> Void) {

    var request: URLRequest = URLRequest(url: URL(string: url)!)
    
    request.httpMethod = methodHttp.rawValue
    
    if parameters != nil {
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
        }catch {
            print(error)
        }
    }
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    getAppDelegate().showActivityIndicator()
    
    URLSession.shared.dataTask(with: request){ (data, response, error) in
        
        guard let data = data, error == nil else {
            if let vc = UIApplication.topViewController(){
            
                vc.showAlertWithErrorMsg(alertMsg:"Something went wrong!!")
            }
            print(error?.localizedDescription ?? "No data")
            return
        }
        do{
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
            completion(responseJSON as AnyObject)
            DispatchQueue.main.async {
                getAppDelegate().hideActivityIndicator()
            }
        }catch{
            print(error)
        }
        
    }.resume()
}
//MARK: - Helper Functions
func changeDateFormat(strDate: String) -> String{
    
    let df = DateFormatter()
    
    df.dateFormat = "yyyy-mm-dd"
    
    if let date = df.date(from: strDate){
        df.dateFormat = "MMM d, yyyy"
        
        return df.string(from: date)
    }
    return ""
}
