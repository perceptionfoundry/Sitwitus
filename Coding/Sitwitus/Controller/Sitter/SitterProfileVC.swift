//
//  SitterProfileVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 06/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import TagListView

class SitterProfileVC: UIViewController {


                                    //******** OUTLETS ***************
     @IBOutlet weak var sitterName: UILabel!
     @IBOutlet weak var sitterSkillTag: TagListView!
     @IBOutlet weak var sitterSpecialistTag: TagListView!
     @IBOutlet weak var sitterProfileImage: Custom_ImageView!





                                   //******** VARIABLES *************

                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     sitterProfileImage.C_Radius = sitterProfileImage.frame.height / 2
     
     sitterSkillTag.addTags(["skill 1", "skill 2", "skill 3"])
     sitterSpecialistTag.addTags(["Specialist 1", "Specialist 2", "Specialist 3"])
    }


     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
          if segue.identifier == "Edit_Segue"{
               
               let dest = segue.destination as! SitterAddSKillVC
               
               dest.placeHolderTitle = sender  as! String
          }
     }

                                    //*************** OUTLET ACTION ******************
     
     @IBAction func addSkillButton(_ sender: UIButton){
              
          
          performSegue(withIdentifier: "Edit_Segue", sender: "SKILL")
         }
     
     @IBAction func addSpecialistButton(_ sender: UIButton){
          
          performSegue(withIdentifier: "Edit_Segue", sender: "SPECIALIST")

         }

     @IBAction func appVideoButton(_ sender: UIButton){
          
     }
     
     @IBAction func submitButton(_ sender: UIButton){
              
         }
     
     @IBAction func backButton(_ sender: UIButton){
          
          self.navigationController?.popViewController(animated: true)
                 
            }
}




                                      //*************** EXTENSION ******************
