//
//  ParentSelectedCardVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 09/03/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class ParentSelectedCardVC: UIViewController {


                                    //******** OUTLETS ***************

@IBOutlet weak var addcardLabe : UILabel!
     @IBOutlet weak var addcardButton : UIButton!

     
     @IBOutlet weak var cardTableView : UITableView!

                                   //******** VARIABLES *************

     var dbStore = Firestore.firestore()
     var cardList = [Card]()
     
     var returnValue : selectCard?
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     cardTableView.isHidden = true
     
     cardTableView.delegate = self
     cardTableView.dataSource = self
     
     self.getCards()
    }

     
     
     //************* GET CARDS
     
     func getCards(){
          
          cardList.removeAll()
          cardTableView.reloadData()
          
          
          
          dbStore.collection("stripe_customers").document((sharedVariable.signInUser?.UserId)!).collection("sources").getDocuments { (sourceResult, sourceErr) in
          
                         guard  let fetchData = sourceResult?.documents  else{return}
          
                         fetchData.forEach { (value) in
          
                              let source = value.data()
                              
                              let getValue = try! FirestoreDecoder().decode(Card.self, from: source)
                              
                              
                              self.cardList.append(getValue)
                              self.cardTableView.reloadData()
                              
                              self.cardTableView.isHidden = false
                              self.addcardLabe.isHidden = true
                              self.addcardButton.isHidden = true
                         }
                     }
          
     }



                                    //*************** OUTLET ACTION ******************

     @IBAction func backButton(){
              self.navigationController?.popViewController(animated: true)
         }
     
     
     @IBAction func continueButton(){
                
          let cardVC = UIStoryboard(name: "Parent", bundle: nil).instantiateViewController(identifier: "CARD_VC")
          self.navigationController?.pushViewController(cardVC, animated: true)
           }
}




                                      //*************** EXTENSION ******************
extension ParentSelectedCardVC: UITableViewDelegate, UITableViewDataSource{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return cardList.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "CARD", for: indexPath) as! CardTableViewCell
          
          
          print(cardList[indexPath.row].last4)
        
          cell.cardNumber.text = "********\(cardList[indexPath.row].last4!)"
          
          
             let brand  = cardList[indexPath.row].brand!
          
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
          
          let selecteCard = cardList[indexPath.row]
          
          returnValue?.cardDetail(cardInfo: selecteCard)
          
          self.navigationController?.popViewController(animated: true)
     }
     
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 100
        }
}
