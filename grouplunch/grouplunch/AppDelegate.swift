//
//  AppDelegate.swift
//  grouplunch
//
//  Created by Randy Melder on 1/30/15.
//  Copyright (c) 2015 RCM Software, LLC. All rights reserved.
//

// MARK: ---------- Roadmap: --------------
// v2.5.1 - (TO DO) Add Photo to email
// v2.6.1 - (TO DO) GPS + Map image ??

// MARK: ---------- Released: -------------
// v2.4.1 - Email integration
// v2.3.1 - Support email, credits
// v2.2.1 - Friendly defaults
// v2.1.1 - iAds
// v2.0.1 - Swift redo

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

// MARK: --------------- COMMON -----------------
    func printLogLine (functionName: String, fileName: String, lineNumber: Int) -> Void {
        let version = self.getAppMinorVersion()
        let appname = self.getAppName()
        self.printLogMessage("- File: \t\t\(fileName) \n- Function: \t\(functionName)() at line: \(lineNumber)")
    }
    
    func printLogMessage (message: String) {
        println("--- \(self.getAppName()) \(self.getAppMinorVersion()):\n\(message)")
    }
    
    func getAppMinorVersion () -> String {
        let appInfo = NSBundle.mainBundle().infoDictionary as Dictionary<String,AnyObject>
        return appInfo["CFBundleVersion"] as String
    }
    
    func getAppMajorVersion () -> String {
        let appInfo = NSBundle.mainBundle().infoDictionary as Dictionary<String,AnyObject>
        return appInfo["CFBundleShortVersionString"] as String
    }
    
    func getAppName() -> String {
        let appInfo = NSBundle.mainBundle().infoDictionary as Dictionary<String,AnyObject>
        return appInfo["CFBundleName"] as String
    }

    
// MARK: --------------- BUILT INs -----------------
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.printLogMessage("Launching app.")
        self.printLogLine("\(__FUNCTION__)", fileName: "\(__FILE__)", lineNumber: __LINE__)
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

