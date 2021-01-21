//
//  CreateStripeViewModel.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 07/03/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import Foundation
import UIKit
import Stripe
import Firebase



class StripeViewModel{
     
     
     let dbStore = Firestore.firestore()
     
     func addCard(userid:String, cardNumber: String, cardExpiry: String, cvv:String,  completion:@escaping (_ Success: Bool, _ err: String?)->()){
          
          
          
          
          print(cardExpiry)
          
          
          let splitDate = cardExpiry.split(separator: "/").map(String.init)
          
          
          let month  = splitDate[0]
          let year = splitDate[1]
          
          
          let cardParams = STPCardParams()
          cardParams.number = cardNumber
          cardParams.expMonth = UInt(month)!
          cardParams.expYear = UInt(year)!
          cardParams.cvc = cvv
          
          
          
          
           STPAPIClient.shared().createToken(withCard: cardParams) { (tokenResult, tokenErr) in
          //                print(tokenResult?.tokenId)
          
          
                          if tokenErr == nil{
          
                              let tokenID = tokenResult?.tokenId
          
                              let dbStore = Firestore.firestore()
          
                              dbStore.collection("stripe_customers").document(userid).collection("tokens").addDocument(data: ["token":tokenID!])
          
                              
                              
                              completion(true, "Card added Successful")
//                      
          
                          }
                          else{
                              completion(false, tokenErr!.localizedDescription)

                          }
                      }
          
          
     }
     
     
     
}
