//
//  AppDelegate.swift
//  Foodlette
//
//  Created by Justin Kampen on 6/27/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DataController.shared.load()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        DataController.shared.saveViewContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DataController.shared.saveViewContext()
    }
}

