//
//  AppDelegate.swift
//  Library-iOS
//
//  Created by Jim Huang on 2025/5/15.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if #available(iOS 16.1, *) {
            LiveActivityManager.sharedInstance.cancelLiveActivity()
        }
    }
}
