//
//  AppDelegate.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 28/02/23.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("In BG  --")
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("GOing FG  --")
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("I'm ACTIVE  --")

    }
    func applicationWillResignActive(_ application: UIApplication) {
        print("going INACTIVE  --")

    }
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("Finish LAUNCHING  --")
    }
    func applicationWillTerminate(_ application: UIApplication) {
        print("WILL TERMINATE  --")
    }
}

