//
//  AppDelegate.swift
//  Children_Book
//
//  Created by Samantha Cannillo on 4/4/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = UserDefaults.standard

    // If the app was terminated while a page was open, automatically open the app to that page upon next launch.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Attribution - https://stackoverflow.com/questions/45888565/segue-to-specific-view-controller-using-appdelegate
        let navigationController = window?.rootViewController as? UINavigationController
        navigationController?.isNavigationBarHidden = true
        
        // 100 signals the app was terminated from a home screen. Navigate to home screen.
        if defaults.integer(forKey: "LastVCIndex") == 100 || defaults.object(forKey: "LastVCIndex") == nil {
            print("App just launched! Navigate to home.")
            return true
            
        // 0,1,2, or 3 in the user default indicate we should open directly to the PageViewController
        // Within the PageViewController, we will open to correctly page upon app termination
        } else {
            print("App just launched! Navigate to page: \(defaults.integer(forKey: "LastVCIndex"))")
            let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootPageViewController")
            navigationController?.pushViewController(newVC, animated: false)
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


}

