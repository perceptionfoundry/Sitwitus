//
//  ParentSignUpReasonVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 10/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class ParentSignUpReasonVC: UIViewController {


                                    //******** OUTLETS ***************


     @IBOutlet var accountButton: [UIButton]!
     @IBOutlet weak var bankTickImage: UIImageView!
     @IBOutlet weak var cardTickImage: UIImageView!
     
     @IBOutlet weak var card_Bank_Label: UILabel!
     
     @IBOutlet weak var left_Label: UILabel!
     @IBOutlet weak var left_TF: UITextField!
     
     @IBOutlet weak var right_Label: UILabel!
      @IBOutlet weak var right_TF: UITextField!
     //******** VARIABLES *************

                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     bankTickImage.isHidden = true
    }



                                    //*************** OUTLET ACTION ******************
     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
     }
     
     
     @IBAction func accountButtonAction(_ sender: UIButton) {
          
          
          //******** BANK SELECTED
          if sender.tag == 0{
               bankTickImage.isHidden = false
               cardTickImage.isHidden = true
               
               card_Bank_Label.text = "Account Number"
               
               left_Label.text = "IBAN #"
               left_TF.placeholder = "XXXXXXX"
               
               right_Label.text = "Swift Code"
               right_TF.placeholder = "XXXXXXX"
               
          }
               
          // ******** CAR SELECT
          else{
               bankTickImage.isHidden = true
               cardTickImage.isHidden = false
               
               
               card_Bank_Label.text = "Card Number"
                        
                        left_Label.text = "Expiry Date"
                        left_TF.placeholder = "MM/YY"
                        
                        right_Label.text = "Security"
                        right_TF.placeholder = "CVV"
          }
     }
     
}




                                      //*************** EXTENSION ******************
