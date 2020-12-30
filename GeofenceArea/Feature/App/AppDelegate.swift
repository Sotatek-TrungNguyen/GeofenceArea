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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        App.shared.switchRoot(type: .mapview)
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
}

