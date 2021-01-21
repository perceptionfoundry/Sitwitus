//
//  ParentProfileVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 13/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import SDWebImage

class ParentProfileVC: UIViewController {


                                    //******** OUTLETS ***************
 
      @IBOutlet weak var parentProfileImage: Custom_ImageView!
     @IBOutlet weak var parentName: UILabel!
     @IBOutlet weak var parentEmail: UITextField!
     @IBOutlet weak var parentMobile: UITextField!
     @IBOutlet weak var parentAddress: UITextField!
     @IBOutlet weak var parentZipcode: UITextField!
     @IBOutlet weak var editButton: UIButton!


                                   //******** VARIABLES *************
     var isEdit = false
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
               parentName.isUserInteractionEnabled = false
              parentEmail.isUserInteractionEnabled = false
              parentMobile.isUserInteractionEnabled =  false
              parentAddress.isUserInteractionEnabled = false
              parentZipcode.isUserInteractionEnabled = false
     
     
     let userProfile = sharedVariable.signInUser!
     
     parentName.text = userProfile.FullName
     parentEmail.text = userProfile.Email
     parentMobile.text =  userProfile.Mobile
     parentAddress.text = userProfile.Location
     parentZipcode.text = userProfile.ZipCode
     
     parentProfileImage.sd_setImage(with: URL(string: userProfile.ImageUrl), placeholderImage: UIImage(named: "profile_Image"), options: .progressiveLoad, completed: nil)
    }



                                    //*************** OUTLET ACTION ******************

     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
     }

     
     @IBAction func editButtonAction(){
          
          
          
          if isEditing == false{
               
               self.isEditing = true
          editButton.setTitle("Save", for: .normal)
          
          parentName.isUserInteractionEnabled = true
          parentEmail.isUserInteractionEnabled = true
          parentMobile.isUserInteractionEnabled =  true
          parentAddress.isUserInteractionEnabled = true
          parentZipcode.isUserInteractionEnabled = true
          parentProfileImage.isUserInteractionEnabled = true
          
          let alert  = AlertWindow()
          alert.simple_Window(Title: "EDIT DESIRE FIELD", Message: "You can edit respective", View: self)
          }
          else{
               self.navigationController?.popViewController(animated: true)
          }
     }

}




                                      //*************** EXTENSION ******************
