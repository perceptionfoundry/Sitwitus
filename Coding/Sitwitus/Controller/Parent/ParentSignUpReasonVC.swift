//
//  ParentSignUpReasonVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 10/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import IQKeyboardManagerSwift

class ParentSignUpReasonVC: UIViewController {


                                    //******** OUTLETS ***************

     //******* UPPER PORTION
     @IBOutlet weak var parentImage: UIImageView!
     @IBOutlet weak var needTF: UITextField!
     @IBOutlet weak var childTF: UITextField!
     @IBOutlet weak var dutyTF: UITextField!
     @IBOutlet weak var durationTF: UITextField!
     @IBOutlet weak var signUpButton: UIButton!
     @IBOutlet weak var activity: UIActivityIndicatorView!
     

     //******** LOWER PORTION
     @IBOutlet var accountButton: [UIButton]!
     @IBOutlet weak var bankTickImage: UIImageView!
     @IBOutlet weak var cardTickImage: UIImageView!
     
     @IBOutlet weak var card_Bank_Label: UILabel!
     @IBOutlet weak var titleTF: UITextField!
     @IBOutlet weak var accountTF: UITextField!
     
     //**** EXPIRY  OR IBAN
     @IBOutlet weak var left_Label: UILabel!
     @IBOutlet weak var left_TF: UITextField!
     
     //**** CVV  OR SWIFT CODE
     @IBOutlet weak var right_Label: UILabel!
     @IBOutlet weak var right_TF: UITextField!
                         
                                   //******** VARIABLES *************
     
     var uploadDict = [String:Any]()
     var parentDP: UIImage!
     var signUpEmail = ""
     var signUpPassword  = ""
     var signUpName = ""
     
     let saveImageVM = SaveImageViewModel()
     
     let alert = AlertWindow()
     
     var lowerPortionSelection = "Credit"

                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     activity.isHidden = true
     bankTickImage.isHidden = true
     parentImage.image = parentDP
    }



                                    //*************** OUTLET ACTION ******************
     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
     }
     
     
     
     @IBAction func accountButtonAction(_ sender: UIButton) {
          
          
          //******** BANK SELECTED
          if sender.tag == 0{
               self.lowerPortionSelection = "Bank"
               bankTickImage.isHidden = false
               cardTickImage.isHidden = true
               
               card_Bank_Label.text = "Account Number"
               
               left_Label.text = "IBAN #"
               left_TF.placeholder = "XXXXXXX"
               
               right_Label.text = "Swift Code"
               right_TF.placeholder = "XXXXXXX"
               
          }
               
          // ******** CARD SELECT
          else{
               self.lowerPortionSelection = "Credit"

               bankTickImage.isHidden = true
               cardTickImage.isHidden = false
               
               
               card_Bank_Label.text = "Card Number"
                        
                        left_Label.text = "Expiry Date"
                        left_TF.placeholder = "MM/YY"
                        
                        right_Label.text = "Security"
                        right_TF.placeholder = "CVV"
          }
     }
     
     
     
     //*********** SIGN UP
     @IBAction func signUpButtonAction(_ sender: Any) {
          
          activity.isHidden = false
          signUpButton.isUserInteractionEnabled = false
          
          
          
          
          
          
          if needTF.text?.isEmpty == false && childTF.text?.isEmpty == false && dutyTF.text?.isEmpty == false && durationTF.text?.isEmpty == false && titleTF.text?.isEmpty == false && accountTF.text?.isEmpty == false && right_TF.text?.isEmpty == false && left_TF.text?.isEmpty == false {
               
               
               //************** Create User
               Auth.auth().createUser(withEmail: signUpEmail, password: signUpPassword) { (authResult, authError) in
                    
                    if authError == nil{
                         
                         self.saveImageVM.SaveImageViewModel(Title: "\(self.signUpName)_Profile", selectedImage: self.parentDP!) { (imageURL, Status, Err) in
                              
                              if Status{
                                   //********* CREATE DATABASE
                                   let dbRef = Firestore.firestore()
                                   
                                   
                                   //**** USERS INFO
                                   
                                   self.uploadDict["ImageUrl"] = imageURL!
                                   self.uploadDict["UserId"] = (authResult?.user.uid)!
                                   
                                   print(self.uploadDict)
                                   
                                   dbRef.collection("Users").document((authResult?.user.uid)!).setData(self.uploadDict)
                                   
                                   
                                   //****** REQUIRMENT
                                   let requirementDict = ["Need":self.needTF.text!,
                                                          "Children":self.childTF.text!,
                                                          "Duty":self.dutyTF.text!,
                                                          "Duration":self.durationTF.text!] as [String : Any]
                                   
                                   dbRef.collection("Users").document((authResult?.user.uid)!).collection("Requirement").document("Value").setData(requirementDict)
                                   
                                   //****** CREDIT /  BANK
                                   //                                                            let AccountDict = ["Title":self.needTF.text!,
                                   //                                                                                   "Account":self.childTF.text!,
                                   //                                                                                   "Expiry_Iban":self.dutyTF.text!,
                                   //                                                                                   "Cvv_Swift":self.durationTF.text!] as [String : Any]
                                   
                                   //                                                            dbRef.collection("Users").document((authResult?.user.uid)!).collection("Requirement").addDocument(data: requirementDict)
                                   
                                   self.navigationController?.popViewController(animated: true)
                              }
                                   
                              else{
                                   self.alert.simple_Window(Title: "IMAGE UPLOAD ERROR", Message: Err!, View: self)
                                   self.activity.isHidden = true
                                   self.signUpButton.isUserInteractionEnabled = true
                              }
                              
                         }
                         
                    }
                         
                    else{
                         self.alert.simple_Window(Title: "CREATE USER ERROR", Message: authError!.localizedDescription, View: self)
                         self.activity.isHidden = true
                         self.signUpButton.isUserInteractionEnabled = true
                    }
                    //
               }
               
               
               
               
          }
               
               
          else{
               alert.simple_Window(Title: "TEXTFIELD EMPTY!", Message: "Please assure all required textfield is filled", View: self)
               activity.isHidden = true
               signUpButton.isUserInteractionEnabled = true
          }
          
          
          
          
          
          
          
          
     }
     
}




                                      //*************** EXTENSION ******************
