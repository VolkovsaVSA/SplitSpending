//
//  AppDelegate.swift
//  SplitSpending
//
//  Created by Sergey Volkov on 15/08/2019.
//  Copyright © 2019 Sergey Volkov. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IAPManager.shared.setupPurchases { success in
            if success {
                print("can make payments")
                IAPManager.shared.getProducts()
            }
        }
        
        if !UserDefaults.standard.bool(forKey: IAPManager.IAPProducts.fullVersion.rawValue) {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
        
        SaveLoadManager.loadHistory()
        
        return true
    }


}

