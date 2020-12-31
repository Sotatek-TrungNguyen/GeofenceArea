//
//  AppDelegate.swift
//  GeofenceArea
//
//  Created by Nguyen Thanh Trung on 12/30/20.
//  Copyright © 2020 Nguyen Thanh Trung. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var reachability: Reachability?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.setupTheme()
        window = UIWindow(frame: UIScreen.main.bounds)
        App.shared.switchRoot(type: .mapview)
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        reachability?.stopNotifier()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        reachability = application.setupReachability()
    }
}

extension UIApplication {
    
    func setupTheme() {
        
    }
    
    func setupReachability() -> Reachability {
        let reachability = try! Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        return reachability
    }

    @objc func reachabilityChanged(note: Notification) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.NotificationKey.wifiChange), object: nil)
    }
}

