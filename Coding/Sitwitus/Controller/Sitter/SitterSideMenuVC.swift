//
//  SitterSideMenuVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 31/01/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class SitterSideMenuVC: UIViewController {


                                    //******** OUTLETS ***************



                                   //******** VARIABLES *************
     
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

     let swipe = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
     swipe.direction = .left
     view.addGestureRecognizer(swipe)
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

     
//***** BACK
     
     @objc func backAction(){
          self.dismiss(animated: true, completion: nil)

     }


                                    //*************** OUTLET ACTION ******************
          @IBAction func familyButton(){
               self.dismiss(animated: true, completion: nil)
          }
     
     @IBAction func logoutButton(){
                   
          let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FIRST")
          UserDefaults.standard.set(false, forKey: "SIGNIN")
          UserDefaults.standard.set(nil, forKey: "SIGN_DETAIL")
          
          self.navigationController?.pushViewController(firstVC, animated: true)
              }
     
     
//     FIRST

}




                                      //*************** EXTENSION ******************
