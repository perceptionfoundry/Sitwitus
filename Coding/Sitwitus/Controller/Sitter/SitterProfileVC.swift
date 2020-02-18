//
//  SitterProfileVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 06/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import TagListView
import SDWebImage
import Firebase

class SitterProfileVC: UIViewController {


                                    //******** OUTLETS ***************
     @IBOutlet weak var sitterName: UILabel!
     @IBOutlet weak var sitterSkillTag: TagListView!
     @IBOutlet weak var sitterSpecialistTag: TagListView!
     @IBOutlet weak var sitterProfileImage: Custom_ImageView!





                                   //******** VARIABLES *************
     let user = sharedVariable.signInUser
     let dbRef = Firestore.firestore()
     var skills = [String]()
     var specialists = [String]()
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     self.initialSetup()
     
     sitterSkillTag.removeAllTags()
     sitterSpecialistTag.removeAllTags()
     
     self.fetchSkill()
     self.fetchSpecialist()
     
    }

     
//********  INITIALIZE SETUP
     
     func initialSetup(){
          
          sitterProfileImage.C_Radius = sitterProfileImage.frame.height / 2.25
          
          sitterName.text = user?.FullName
          
          sitterProfileImage.sd_setImage(with: URL(string: (user?.ImageUrl)!), placeholderImage: UIImage(named: "new_image"), options: .progressiveLoad, completed: nil)
     }
     
//********* FETCH PROFILE
     
     func fetchSkill(){
          
          dbRef.collection("Users").document((sharedVariable.signInUser?.userId)!).collection("Profile").document("Skill").getDocument { (docSnap, docErr) in
               
               let fetchValue = docSnap?.data() as! [String:[String]]
               
               self.skills = fetchValue["Value"]!
               
               self.sitterSkillTag.addTags(self.skills)
          }
          
     }
     
     
     
     func fetchSpecialist(){
          
          dbRef.collection("Users").document((sharedVariable.signInUser?.userId)!).collection("Profile").document("Specialist").getDocument { (docSnap, docErr) in
               
               let fetchValue = docSnap?.data() as! [String:[String]]
               
               self.specialists = fetchValue["Value"]!
               
               self.sitterSpecialistTag.addTags(self.specialists)
          }
          
     }


     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
          if segue.identifier == "Edit_Segue"{
               
               let dest = segue.destination as! SitterAddSKillVC
               
               
               
               
               if (sender as! String) == "SKILL"{
                    
                    dest.newList = self.skills
               }
                    
               else{
                    dest.newList = self.specialists
               }
               
               
               
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
