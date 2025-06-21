/**
 @file AppDelegate.swift
 @project AppContest2025_Macintustin
 
 @brief Application delegate and launch configuration.
 @details
  AppDelegate handles the initial setup and lifecycle events of the application.

  It performs the following tasks:
  - Initializes a shared `LikeManager` instance to manage user "likes"
  - Creates the root SwiftUI view (`StartView`) and injects the environment object
  - Sets up a `UIWindow` with a `UIHostingController` to bridge UIKit and SwiftUI
  - Manages app lifecycle callbacks such as backgrounding and foregrounding

  This file serves as the entry point for the app using the `@main` attribute.
 
 @author 赵禹惟
 @date 2025/4/16
 */

import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let likeManager = LikeManager()
        
        // Create the SwiftUI view that provides the window contents.
        let startView = StartView()
            .environmentObject(likeManager)

        // Use a UIHostingController as window root view controller.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: startView)
        self.window = window
        window.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}
