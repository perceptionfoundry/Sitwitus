//
//  ParentSignInVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 10/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class ParentSignInVC: UIViewController {


                                    //******** OUTLETS ***************



                                   //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }



                                    //*************** OUTLET ACTION ******************
     @IBAction func backButtonAction(){
              
              self.navigationController?.popViewController(animated: true)
         }

}




                                      //*************** EXTENSION ******************
