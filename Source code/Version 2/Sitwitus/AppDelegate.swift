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
import FirebaseMessaging
import Stripe



// Firebase notification token
var usrFcmToken = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var googleAPIkey = "AIzaSyDvFcxQjJfvYASX7uxovvCvRMKVpekVk7E"
     
     var signInUser : Users?
     var isSignIn = false
     var stripeCustomerID = ""
     
     var tempDict = [String:Any]()
     
     
     var gcmMessageIDKey = "gcm.Message_IDKey"
  


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
     
     FirebaseApp.configure()
     
     IQKeyboardManager.shared.enable = true
     Messaging.messaging().delegate = self
    
     GMSServices.provideAPIKey(googleAPIkey)
     
     
     if #available(iOS 10.0, *) {
       // For iOS 10 display notification (sent via APNS)
       UNUserNotificationCenter.current().delegate = self

       let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
       UNUserNotificationCenter.current().requestAuthorization(
         options: authOptions,
         completionHandler: {_, _ in })
     } else {
       let settings: UIUserNotificationSettings =
       UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
       application.registerUserNotificationSettings(settings)
     }

     application.registerForRemoteNotifications()

     
     
     
    
     
     
     StripeAPI.defaultPublishableKey = "pk_test_o8kIqRmXgSKq19OFCVOSc7rH00Bc0LCfgJ"
//             Stripe.setDefaultPublishableKey("pk_test_o8kIqRmXgSKq19OFCVOSc7rH00Bc0LCfgJ")


        return true
    }
     
     
     
     
     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       // If you are receiving a notification message while your app is in the background,
       // this callback will not be fired till the user taps on the notification launching the application.
       // TODO: Handle data of notification

       // With swizzling disabled you must let Messaging know about the message, for Analytics
       // Messaging.messaging().appDidReceiveMessage(userInfo)

       // Print message ID.
       if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
       }

       // Print full message.
       print(userInfo)

       completionHandler(UIBackgroundFetchResult.newData)
     }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
       
    }


}

//MARK: MessagingDelegate
extension AppDelegate: MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      
     
//     print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
     
     
    
     
     
     let authStatus = UserDefaults.standard.bool(forKey: "SIGNIN")
     
     print(authStatus)
     
     if authStatus{
         
          print("Firebase registration token: \(String(describing: fcmToken))")
          
          usrFcmToken = fcmToken!
         

          let dbRef = Firestore.firestore()
          dbRef.collection("Users").document((Auth.auth().currentUser?.uid)!).updateData(["fcmToken":usrFcmToken])
          
//         profileVM.EditProfile(textValue: ["pushToken":usrFcmToken]) { (status, info) in
//             
//             if status{
//                 
//                 print("added fcm tokenn")
//                 
//             }else{
//                 print(info)
//             }
//         }
         
     }
     
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

//MARK: UNUserNotificationCenterDelegate
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}
