//
//  CheckOutVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 27/01/2021.
//  Copyright © 2021 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Firebase

class CheckOutVC: UIViewController {
     
     
     
     @IBOutlet weak var parentImage : UIImageView!
     @IBOutlet weak var parentStar : HCSStarRatingView!
     
     
     
     var rateValue: CGFloat = 0.0
     var parentUid = selectedAppointment.ParentUid
     
     override func viewDidLoad() {
         super.viewDidLoad()

         // Do any additional setup after loading the view.
          
          parentStar.value = 0
          print(parentUid)
          
     }
     
     
     
     func getDateDiff(start: Date, end: Date) -> Int  {
         let calendar = Calendar.current
         let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)

         let seconds = dateComponents.second
         return Int(seconds!)
     }


      
      
      @IBAction func continueButton(){
          
          
          
          if parentStar.value != 0.0{
               
               
               
               let dbStore = Firestore.firestore()
               
               dbStore.collection("Users").document(parentUid!).updateData(["Star": parentStar.value])
          }
           
          
          
          
                      let story = UIStoryboard(name: "Sitter", bundle: nil)
                      let vc = story.instantiateViewController(withIdentifier: "SITTER_MAIN")
                      
                      self.navigationController?.pushViewController(vc, animated: true)
                  
             }

  

 }
