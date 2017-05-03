//
//  AppDelegate.swift
//  Movie
//
//  Created by Aditya Tanna on 4/26/17.
//  Copyright © 2017 Tanna Inc. All rights reserved.
//

import UIKit
import SystemConfiguration

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    let reachability = Reachability()!

    var viewActivity:UIView!
    
    var indicator:UIActivityIndicatorView?
    
    let cache = NSCache <AnyObject , AnyObject>()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let splitViewController = window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        
    
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
    //MARK: - SHOW & HIDE ACTIVITY INDICATOR
    func showActivityIndicator() {
        
        if((viewActivity == nil)){
            viewActivity = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            viewActivity.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
            indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            indicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            indicator?.startAnimating()
            
            let lbl:UILabel = UILabel(frame: CGRect(x: 3, y: 0, width: (viewActivity.frame.size.width) - 6, height: 30))
            lbl.numberOfLines = 0
            lbl.backgroundColor = UIColor.clear
            lbl.textColor = UIColor.white
            lbl.font = UIFont(name: "HelveticaNeue", size: 15.0)
            lbl.textAlignment = NSTextAlignment.center
            lbl.text = "Loading..."
            
            indicator!.center = CGPoint(x: (viewActivity.center.x), y: (viewActivity.center.y) - ((indicator?.frame.size.height)! / 4))
            
            lbl.center = CGPoint(x: (viewActivity.center.x), y: (indicator?.frame)!.maxY + ((indicator?.frame.size.height)! / 4))
            
            viewActivity.addSubview(lbl)
        }else{
            indicator?.center = (viewActivity.center)
        }
        
        viewActivity.addSubview(indicator!)
        viewActivity.layer.cornerRadius = 10
        viewActivity.center = (self.window?.center)!
        
        self.window?.addSubview(viewActivity)
    }
    
    func hideActivityIndicator(){
        if(viewActivity != nil){
            indicator?.stopAnimating()
            viewActivity.removeFromSuperview()
            indicator = nil
            viewActivity = nil
        }
    }
}
