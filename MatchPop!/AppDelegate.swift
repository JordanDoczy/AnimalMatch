//
//  AppDelegate.swift
//  AnimalMatch
//
//  Created by Jordan Doczy on 11/23/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let attr = NSDictionary(object: UIFont(name: "ChalkboardSE-Light", size: 16.0)!, forKey: NSFontAttributeName as NSCopying) as! [AnyHashable: Any]
        UISegmentedControl.appearance().setTitleTextAttributes(attr, for: UIControlState())
        
        return true
    }
}
