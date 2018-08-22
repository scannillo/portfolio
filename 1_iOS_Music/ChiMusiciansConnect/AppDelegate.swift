//
//  AppDelegate.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 2/26/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchFromTerminated = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize and configure the firebase
        FirebaseApp.configure()
        
        // Change boolean to 'true'. We launched
        self.launchFromTerminated = true
        registerSettings()
        
        // Setup FacebookDSK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    // Attribution: - https://developers.facebook.com/docs/ios/getting-started
    // Setup FacebookSDK
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handle
    }
    
    // Handle Settings.bundle information. Stores developer name and initial app launch date.
    func registerSettings() {
        print("App launched. Register settings called.")
        
        //Find app first launch date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let result = formatter.string(from: date)
        print(result)
        
        UserDefaults.standard.register(defaults: ["developer_name" : "Samantha Cannillo"])
        UserDefaults.standard.set(result, forKey: "first_launch_date")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Did enter background")
        showSplashScreen(autoDismiss: true)
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Did become active.")
        print("bool of launchFromTerminated: \(launchFromTerminated)")
        if launchFromTerminated == true {
            showSplashScreen(autoDismiss: true)
            launchFromTerminated = false
        }
    }

}

// MARK: Attributions - Andrew Binkowski
extension AppDelegate {
    
    // Load the SplashViewController from Splash.storyboard
    func showSplashScreen(autoDismiss: Bool) {
        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        
        //Control behavior from suspended to launch
        controller.autoDismiss = autoDismiss
        
        //Present the VC over the current top
        let vc = topController()
        vc.present(controller, animated: false, completion: nil)
    }
    
    // Determines the top VC on screen
    // Returns that VC
    func topController(_ parent:UIViewController? = nil) -> UIViewController {
        if let vc = parent {
            if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
                return topController(selected)
            } else if let nav = vc as? UINavigationController, let top = nav.topViewController {
                return topController(top)
            } else if let presented = vc.presentedViewController {
                return topController(presented)
            } else {
                return vc
            }
        } else {
            return topController(UIApplication.shared.keyWindow!.rootViewController!)
        }
    }
}

