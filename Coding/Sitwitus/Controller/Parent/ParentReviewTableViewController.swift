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

class ParentReviewTableViewController: UITableViewController {


                                    //******** OUTLETS ***************
     @IBOutlet weak var dateLabel : UILabel!
     @IBOutlet weak var sitterName : UILabel!
      @IBOutlet weak var sitterReview : HCSStarRatingView!
      @IBOutlet weak var sitterImage : UIImageView!
     
     @IBOutlet weak var parentAddress : UILabel!
     @IBOutlet weak var paymentSourceImage : UIImageView!
     @IBOutlet weak var sitterRate : UILabel!
     @IBOutlet weak var sitterHourDetail : UILabel!
      @IBOutlet weak var calculation : UILabel!
     @IBOutlet weak var amountTotal : UILabel!
     


                                   //******** VARIABLES *************
     let finalDict = sharedVariable.tempDict
     var dateString = ""
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

      

     
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



                                    //*************** OUTLET ACTION ******************

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 5
     }

}




                                      //*************** EXTENSION ******************
