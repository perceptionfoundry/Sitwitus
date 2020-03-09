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
     let stripeVM = StripeViewModel()
     
     var lowerPortionSelection = "Credit"

                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
     accountTF.delegate = self
         left_TF.delegate = self
     right_TF.delegate = self
3    }

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
                                   
                                   
                                   //********* CREATE CREDIT CARD
                                   self.stripeVM.addCard(userid: (authResult?.user.uid)!, cardNumber: self.accountTF.text!, cardExpiry: self.left_TF.text!, cvv: self.right_TF.text!, completion: { (status, Message) in
                                        
                                        
                                        if status{
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
                                             
                                             //                                   self.navigationController?.popViewController(animated: true)
                                             
                                             let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FIRST")
                                             UserDefaults.standard.set(false, forKey: "SIGNIN")
                                             UserDefaults.standard.set(nil, forKey: "SIGN_DETAIL")
                                             
                                             self.navigationController?.pushViewController(firstVC, animated: true)
                                        }
                                        else{
                                             
                                             self.alert.simple_Window(Title: "Failed TO CARD", Message: Message!, View: self)

                                        }
                                        
                                        
                                        
                                        
                                   })
                                   
                                   
                                   
                                   
                                   
                                   
                                   
                                  
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


extension ParentSignUpReasonVC: UITextFieldDelegate{
     
     
     
     
         func textFieldDidBeginEditing(_ textField: UITextField) {
             
             
             if textField == left_TF{
     //                self.showDatePicker()
                 
                 
                 
                 let expiryDatePicker = MonthYearPickerView()
                 
                 left_TF.inputView = expiryDatePicker
                 
                        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
                                let selection = String(format: "%02d/%d", month, year)
                         self.left_TF.text = selection

                        }
                 
                 
             
                 }
                 
             
             else{
                 textField.inputView = nil
             }
          
         }

     
     
     
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         
          
          
     
          
          
          
          if textField == right_TF{
             
             if right_TF.text!.count > 2{
                 textField.endEditing(true)

             }
             else{
             }
            }
         
            else if textField == accountTF{
             if textField.text!.count > 15{
                 textField.endEditing(true)
                       }
                       else{
                       }
         }
         
         
         return true
     }

     
}




