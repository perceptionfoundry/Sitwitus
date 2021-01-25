//
//  AppDelegate.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 28/01/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import Firebase
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var googleAPIkey = "AIzaSyDvFcxQjJfvYASX7uxovvCvRMKVpekVk7E"
     
     var signInUser : Users?
     var isSignIn = false
     var stripeCustomerID = ""
     
     var tempDict = [String:Any]()
  

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
     
     IQKeyboardManager.shared.enable = true
     
     
     GMSServices.provideAPIKey(googleAPIkey)
     
     FirebaseApp.configure()
     
     
     StripeAPI.defaultPublishableKey = "pk_test_o8kIqRmXgSKq19OFCVOSc7rH00Bc0LCfgJ"
//             Stripe.setDefaultPublishableKey("pk_test_o8kIqRmXgSKq19OFCVOSc7rH00Bc0LCfgJ")


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


}

