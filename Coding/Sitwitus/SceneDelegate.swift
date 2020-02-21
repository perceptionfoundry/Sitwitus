//
//  SceneDelegate.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 28/01/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
     
     let status  = UserDefaults.standard.bool(forKey: "SIGNIN")
     let whoIsIt = UserDefaults.standard.bool(forKey: "isParent")
  
     if status == true && whoIsIt == false {
               let userDetail = UserDefaults.standard.dictionary(forKey: "SIGN_DETAIL")
               
               let usr = Users.userDetail
          
               // ********* MAPPING
               usr.FullName = (userDetail!["FullName"] as! String)
               usr.Email = (userDetail!["Email"] as! String)
               usr.Gender = (userDetail!["Gender"] as! String)
               usr.Mobile = (userDetail!["Mobile"] as! String)
              usr.Location = (userDetail!["Location"] as! String)
               usr.Lat = (userDetail!["Lat"] as! Double)
               usr.Long = (userDetail!["Long"] as! Double)
               usr.Rate = (userDetail!["Rate"] as! Double)
               usr.UserId = (userDetail!["UserId"] as! String)
               usr.ImageUrl = (userDetail!["ImageUrl"] as! String)
          usr.ZipCode = (userDetail!["ZipCode"] as! String)

 
               sharedVariable.signInUser = usr
               
               
               let sitter = UIStoryboard(name: "Sitter", bundle: nil).instantiateViewController(identifier: "SITTER_MAIN")
     
               self.window?.rootViewController?.addChild(sitter)
               

          }
     
     
     if status == true && whoIsIt == true {
                   let userDetail = UserDefaults.standard.dictionary(forKey: "SIGN_DETAIL")
                   
                   let usr = Users.userDetail
              
                   // ********* MAPPING
                   usr.FullName = (userDetail!["FullName"] as! String)
                   usr.Email = (userDetail!["Email"] as! String)
                   usr.Gender = (userDetail!["Gender"] as! String)
                   usr.Mobile = (userDetail!["Mobile"] as! String)
                  usr.Location = (userDetail!["Location"] as! String)
                   usr.Lat = (userDetail!["Lat"] as! Double)
                   usr.Long = (userDetail!["Long"] as! Double)
                   usr.ZipCode = (userDetail!["ZipCode"] as! String)
                   usr.UserId = (userDetail!["UserId"] as! String)
                   usr.ImageUrl = (userDetail!["ImageUrl"] as! String)
     
                   sharedVariable.signInUser = usr
                   
                   
                   let parent = UIStoryboard(name: "Parent", bundle: nil).instantiateViewController(identifier: "MAIN")
         
                   self.window?.rootViewController?.addChild(parent)
                   

              }
     
     
     
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

