//
//  UserSelectorVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 28/01/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class UserSelectorVC: UIViewController {

   
                                     //******** OUTLETS ***************



                                 //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
               
     var mode = "Sitter_Segue"
                                 //********* FUNCTIONS ***************
         
         
     //******* VIEW FUNCTIONS

      override func viewDidLoad() {
             super.viewDidLoad()

             
         }

       override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(animated)
         }



                                  //*************** OUTLET ACTION ******************
     @IBAction func selectorSwitchAction(_ segment_Switch: Custom_Segment){
          
          let index = segment_Switch.selectedSegmentIndex
          
          
          if index == 0{
             
               self.mode = "Sitter_Segue"
          }
          else{
               self.mode = "Parent_Segue"


          }
          
          print(self.mode)
          
     }

     
     
     @IBAction func continueButtonAction(){
          self.performSegue(withIdentifier: self.mode, sender: nil)
     }
     
     
     }




                                 //*************** EXTENSION ******************
