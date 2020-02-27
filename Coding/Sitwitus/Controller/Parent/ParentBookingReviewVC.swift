//
//  ParentBookingReviewVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 13/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase


class ParentBookingReviewVC: UIViewController {


                                    //******** OUTLETS ***************


     @IBOutlet weak var container_View: UIView!
     
     
                                   //******** VARIABLES *************
     var bookingDict = [String:Any]()
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     

    }



                                    //*************** OUTLET ACTION ******************

     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
     }
     
     @IBAction func confirmButton(){
          
          
          
          let dbStore = Firestore.firestore()
          
          let colletionRef = dbStore.collection("Requests").document()
          
          self.bookingDict["Time"] = FieldValue.serverTimestamp()
          self.bookingDict["requestUid"] = colletionRef.documentID
          
          colletionRef.setData(self.bookingDict)
          
          
          
          let story = UIStoryboard(name: "Parent", bundle: nil)
          let vc = story.instantiateViewController(withIdentifier: "MAIN")
          
          self.navigationController?.pushViewController(vc, animated: true)
     }

}




                                      //*************** EXTENSION ******************
