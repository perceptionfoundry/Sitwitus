//
//  ParentPaymentVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 13/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class ParentPaymentVC:  UIViewController {


                                    //******** OUTLETS ***************

     @IBOutlet weak var cardTable : UITableView!
     
     @IBOutlet weak var addCardView : UIView!

      @IBOutlet weak var addHighlighter : UIView!
      @IBOutlet weak var cardHighlighter : UIView!
     
     
     
     @IBOutlet weak var bankTickImage: UIImageView!
        @IBOutlet weak var cardTickImage: UIImageView!
        
      @IBOutlet weak var titleTF: UITextField!
     
        @IBOutlet weak var card_Bank_Label: UILabel!
     @IBOutlet weak var card_Bank_TF: UITextField!
        
        @IBOutlet weak var left_Label: UILabel!
        @IBOutlet weak var left_TF: UITextField!
        
        @IBOutlet weak var right_Label: UILabel!
         @IBOutlet weak var right_TF: UITextField!

                                   //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
        
     var dbStore = Firestore.firestore()
     
     var myCards = [Card]()
     
     var stripeVM = StripeViewModel()
     
     let alert = AlertWindow()
     
  
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     cardTable.delegate = self
     cardTable.dataSource = self
     cardTable.reloadData()
     
     addHighlighter.isHidden = true
     addCardView.isHidden = true
     bankTickImage.isHidden = true
     
     
     card_Bank_TF.delegate = self
            left_TF.delegate = self
        right_TF.delegate = self
     
     self.getCards()
    }

//************* GET CARDS
     
     func getCards(){
          
          myCards.removeAll()
          cardTable.reloadData()
          
          
          
          dbStore.collection("stripe_customers").document((sharedVariable.signInUser?.UserId)!).collection("sources").getDocuments { (sourceResult, sourceErr) in
          
                         guard  let fetchData = sourceResult?.documents  else{return}
          
                         fetchData.forEach { (value) in
          
                              let source = value.data()
                              
                              let getValue = try! FirestoreDecoder().decode(Card.self, from: source)
                              
                              
                              self.myCards.append(getValue)
                              self.cardTable.reloadData()
          
          
                         }
                     }
          
     }
     
     
 //************* ADD CARDS
     
     func addCard(){
          
          
          if titleTF.text?.isEmpty == false && card_Bank_TF.text?.isEmpty == false && left_TF.text?.isEmpty == false && right_TF.text?.isEmpty == false{
               
               
               //********* CREATE CREDIT CARD
               
               print(self.card_Bank_TF.text!)
               print(self.left_TF.text!)
               print(self.right_TF.text!)
               
                        self.stripeVM.addCard(userid: (sharedVariable.signInUser?.UserId)!, cardNumber: self.card_Bank_TF.text!, cardExpiry: self.left_TF.text!, cvv: self.right_TF.text!, completion: { (status, Message) in
                             
                             
                             if status{
                                self.alert.simple_Window(Title: "CARD ADDED", Message: "Your new card has been added", View: self)
                              self.getCards()

                             }
                             else{
                                  
                                  self.alert.simple_Window(Title: "Failed TO CARD", Message: Message!, View: self)

                             }
                             
                             
                             
                             
                        })
               
               
          }
          else{
               self.alert.simple_Window(Title: "TEXTFIELD EMPTY!", Message: "Please assure all desire fields are filled", View: self)
          }
          
         
          
     }


                                    //*************** OUTLET ACTION ******************

     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
          
     }
     
     
     @IBAction func selectionButton(_ sender: UIButton){
              
          let selectedButton = sender.tag
          
          if selectedButton == 0{
               addHighlighter.isHidden = false
               cardHighlighter.isHidden = true
               addCardView.isHidden = false
               cardTable.isHidden = true


          }
          else{
               addHighlighter.isHidden = true
               cardHighlighter.isHidden = false
               addCardView.isHidden = true
               cardTable.isHidden = false


          }
          
         }
     
     
     @IBAction func addButtonAction(_ sender: UIButton) {
          
          self.addCard()
          
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
               
          // ******** CARD SELECT
          else{
               bankTickImage.isHidden = true
               cardTickImage.isHidden = false
               
               
               card_Bank_Label.text = "Card Number"
                        
                        left_Label.text = "Expiry Date"
                        left_TF.placeholder = "MM/YY"
                        
                        right_Label.text = "Security"
                        right_TF.placeholder = "CVV"
               
               self.addCard()
          }
     }
     
}




                                      //*************** EXTENSION ******************

extension ParentPaymentVC: UITableViewDelegate, UITableViewDataSource{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return myCards.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "CARD", for: indexPath) as! CardTableViewCell
          
          
          print(myCards[indexPath.row].last4)
        
          cell.cardNumber.text = "********\(myCards[indexPath.row].last4!)"
          
          
             let brand  = myCards[indexPath.row].brand!
          
          cell.cardName.text = "\(brand)"

          
          print(brand)
             
             if brand == "Visa"{
             
                 cell.cardImage.image = UIImage(named: "visa")
             }
             
             else if brand == "MasterCard"{
             
                 cell.cardImage.image = UIImage(named: "master")
             }
             
             else if brand == "American Express"{
             
                 cell.cardImage.image = UIImage(named: "american")
             }
             
             else if brand == "Paypal"{
             
                 cell.cardImage.image = UIImage(named: "paypal")
             }
   

          return cell
     }
     
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
   
          
     }
     
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 100
        }
}




extension ParentPaymentVC: UITextFieldDelegate{
     
     
     
     
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
         
            else if textField == card_Bank_TF{
             if textField.text!.count > 15{
                 textField.endEditing(true)
                       }
                       else{
                       }
         }
         
         
         return true
     }

     
}
