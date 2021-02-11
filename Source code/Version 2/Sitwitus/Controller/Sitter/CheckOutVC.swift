//
//  CheckOutVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 27/01/2021.
//  Copyright © 2021 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import HCSStarRatingView

class CheckOutVC: UIViewController {
     
     
     
     @IBOutlet weak var parentImage : UIImageView!
     @IBOutlet weak var parentStar : HCSStarRatingView!
     
     
     
     var rateValue = 1
     
     override func viewDidLoad() {
         super.viewDidLoad()

         // Do any additional setup after loading the view.
          
     print(parentStar.value)
     }
     
     
     
     func getDateDiff(start: Date, end: Date) -> Int  {
         let calendar = Calendar.current
         let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)

         let seconds = dateComponents.second
         return Int(seconds!)
     }


      
      
      @IBAction func continueButton(){
                      let story = UIStoryboard(name: "Sitter", bundle: nil)
                      let vc = story.instantiateViewController(withIdentifier: "SITTER_MAIN")
                      
                      self.navigationController?.pushViewController(vc, animated: true)
                  
             }

  

 }
