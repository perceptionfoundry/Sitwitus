//
//  ParentBookingReviewVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 13/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class ParentBookingReviewVC: UIViewController {


                                    //******** OUTLETS ***************



                                   //******** VARIABLES *************

                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }



                                    //*************** OUTLET ACTION ******************

     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
     }
     
     @IBAction func confirmButton(){
          
          let story = UIStoryboard(name: "Parent", bundle: nil)
          let vc = story.instantiateViewController(withIdentifier: "MAIN")
          
          self.navigationController?.pushViewController(vc, animated: true)
     }

}




                                      //*************** EXTENSION ******************
