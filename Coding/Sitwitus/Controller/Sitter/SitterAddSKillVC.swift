//
//  SitterAddSKillVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 06/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import TagListView
import Firebase

class SitterAddSKillVC: UIViewController {


                                    //******** OUTLETS ***************
     @IBOutlet weak var addTitle: UILabel!

     @IBOutlet weak var addTF: UITextField!
     @IBOutlet weak var addTag: TagListView!


                                   //******** VARIABLES *************

     var placeHolderTitle = ""
     var newList = [String]()
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
     print(newList)
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     self.addTitle.text = "Add \(placeHolderTitle)"
     self.addTF.placeholder = placeHolderTitle.lowercased()
     
     print(placeHolderTitle)
     
     if placeHolderTitle == "SKILL"{
          
     }
     else{
          
     }
    }



                                    //*************** OUTLET ACTION ******************

     @IBAction func addButton(_ sender: UIButton){
                  
    
               self.newList.append((addTF.text)!)

         
          
          addTag.addTag(addTF.text!)
          addTF.text = ""
          
          
          
              }
     
     @IBAction func submitButton(_ sender: UIButton){
      
          let dbRef  = Firestore.firestore()
          
          
          if placeHolderTitle == "SKILL"{
           
          dbRef.collection("Users").document((sharedVariable.signInUser?.userId)!).collection("Profile").document("Skill").setData(["Value": self.newList])
               
             self.dismiss(animated: true, completion: nil)
          }
          else{
               dbRef.collection("Users").document((sharedVariable.signInUser?.userId)!).collection("Profile").document("Specialist").setData(["Value": self.newList])
              
               self.dismiss(animated: true, completion: nil)
  
          }
          
     }
}




                                      //*************** EXTENSION ******************
