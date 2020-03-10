//
//  ParentReviewTableViewController.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 27/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import HCSStarRatingView
import SDWebImage


protocol selectCard {
     
     func cardDetail(cardInfo : Card)
     
}

class ParentReviewTableViewController: UITableViewController, selectCard {
    
     
     func cardDetail(cardInfo: Card) {
          
          self.cardDetails = cardInfo
         
          let brand = cardInfo.brand!
          let parentVC = ParentBookingReviewVC()
          
          parentVC.customerID = cardInfo.id!
          
          print(brand)
          if brand == "Visa"{
                      
                         paymentSourceImage.image = UIImage(named: "visa")
                      }
                      
                      else if brand == "MasterCard"{
                      
                         paymentSourceImage.image = UIImage(named: "master")
                      }
                      
                      else if brand == "American Express"{
                      
                          paymentSourceImage.image = UIImage(named: "american")
                      }
                      
                      else if brand == "Paypal"{
                      
                          paymentSourceImage.image = UIImage(named: "paypal")
                      }
          self.paymentSourceImage.isHidden = false
          self.paymentSource.isHidden = true
          
          sharedVariable.stripeCustomerID = cardInfo.customer!
          
          
     }
     


                                    //******** OUTLETS ***************
     @IBOutlet weak var dateLabel : UILabel!
     @IBOutlet weak var sitterName : UILabel!
      @IBOutlet weak var sitterReview : HCSStarRatingView!
      @IBOutlet weak var sitterImage : UIImageView!
     
     @IBOutlet weak var parentAddress : UILabel!
     @IBOutlet weak var paymentSource : UILabel!
     @IBOutlet weak var paymentSourceImage : UIImageView!
     @IBOutlet weak var sitterRate : UILabel!
     @IBOutlet weak var sitterHourDetail : UILabel!
      @IBOutlet weak var calculation : UILabel!
     @IBOutlet weak var amountTotal : UILabel!
     


                                   //******** VARIABLES *************
     let finalDict = sharedVariable.tempDict
     var dateString = ""
     var cardDetails : Card?
     
    
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

      
     paymentSourceImage.isHidden = true

     
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     
     
     print("************ FINAL **************")
        print(finalDict)
        print("**************************")
     
     
     let curretnDate = Date()
     let formattor = DateFormatter()
     formattor.dateFormat = "EEEE, MMM dd "
     self.dateString = formattor.string(from: curretnDate)
     
     dateLabel.text = self.dateString
     sitterName.text = (finalDict["SitterName"] as! String)
     parentAddress.text = (sharedVariable.signInUser?.Location)!
     sitterRate.text = "$\(finalDict["Rate"] as! Double)/hr"
     sitterReview.value = CGFloat((finalDict["SitterReview"] as! Double))
     sitterImage.sd_setImage(with: URL(string: finalDict["SitterImage"] as! String), placeholderImage: UIImage(named: "profile_Image"), options: .progressiveLoad, completed: nil)
     
     
     let detail = "$\((finalDict["Rate"])!) X \((finalDict["Hours"])!) hours"
     sitterHourDetail.text = detail
     
     let hr = Double(finalDict["Hours"] as! String)!
     let cal = (finalDict["Rate"] as! Double) * (hr)
     
     calculation.text = "$ \(cal)"
     amountTotal.text = "$ \(cal)"
     
     
     
    }
     
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
          if segue.identifier == "CARDS_SEGUE"{
               
               let dest = segue.destination as! ParentSelectedCardVC
               
               dest.returnValue = self
               
          }
     }




                                    //*************** OUTLET ACTION ******************

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 5
     }

     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          print(indexPath.row)
          
          performSegue(withIdentifier: "CARDS_SEGUE", sender: nil)
     }
     
     
}




                                      //*************** EXTENSION ******************

