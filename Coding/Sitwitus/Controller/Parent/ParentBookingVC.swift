//
//  ParentBookingVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 12/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class ParentBookingVC: UIViewController {


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

}




                                      //*************** EXTENSION ******************
