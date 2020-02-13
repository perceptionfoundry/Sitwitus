//
//  ParentPaymentVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 13/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class ParentPaymentVC:  UIViewController {


                                    //******** OUTLETS ***************

     @IBOutlet weak var cardTable : UITableView!
     
     @IBOutlet weak var addCardView : UIView!

      @IBOutlet weak var addHighlighter : UIView!
      @IBOutlet weak var cardHighlighter : UIView!
     
     
     
     @IBOutlet weak var bankTickImage: UIImageView!
        @IBOutlet weak var cardTickImage: UIImageView!
        
        @IBOutlet weak var card_Bank_Label: UILabel!
        
        @IBOutlet weak var left_Label: UILabel!
        @IBOutlet weak var left_TF: UITextField!
        
        @IBOutlet weak var right_Label: UILabel!
         @IBOutlet weak var right_TF: UITextField!

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
     
     cardTable.delegate = self
     cardTable.dataSource = self
     cardTable.reloadData()
     
     addHighlighter.isHidden = true
     addCardView.isHidden = true
     bankTickImage.isHidden = true
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

extension ParentPaymentVC: UITableViewDelegate, UITableViewDataSource{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 3
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "CARD", for: indexPath) 
          
        
   

          return cell
     }
     
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
   
          
     }
     
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 100
        }
}
