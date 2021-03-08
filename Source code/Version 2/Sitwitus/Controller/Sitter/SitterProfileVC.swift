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


protocol Refresh {
     
     func refreshScreen()
}

class SitterProfileVC: UIViewController, Refresh {
    
     func refreshScreen() {
          
          sitterSkillTag.removeAllTags()
          sitterSpecialistTag.removeAllTags()
          
          self.fetchSkill()
          self.fetchSpecialist()

     }
     


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
          
          sitterProfileImage.sd_setImage(with: URL(string: (user?.ImageUrl)!), placeholderImage: UIImage(named: "profile_Image"), options: .progressiveLoad, completed: nil)
     }
     
//********* FETCH PROFILE
     
     func fetchSkill(){
          
          dbRef.collection("Users").document((sharedVariable.signInUser?.UserId)!).collection("Profile").document("Skill").getDocument { (docSnap, docErr) in
               
               guard  let fetchValue = docSnap?.data() else{return}

               self.skills = fetchValue["Value"] as! [String]
               
               self.sitterSkillTag.addTags(self.skills)
          }
          
     }
     
     
     
     func fetchSpecialist(){
          
          dbRef.collection("Users").document((sharedVariable.signInUser?.UserId)!).collection("Profile").document("Specialist").getDocument { (docSnap, docErr) in
               
               guard  let fetchValue = docSnap?.data()  else{return}
               
               self.specialists = fetchValue["Value"] as! [String]
               
               self.sitterSpecialistTag.addTags(self.specialists)
          }
          
     }


     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
          if segue.identifier == "Edit_Segue"{
               
               let dest = segue.destination as! SitterAddSKillVC
               
               
               
               dest.refreshProtocol = self
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
          
          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          
          imagePicker.sourceType = .photoLibrary
          imagePicker.mediaTypes = ["public.movie"]
          
          self.present(imagePicker, animated: true, completion: nil)
          
     }
     
     @IBAction func submitButton(_ sender: UIButton){
              
         }
     
     @IBAction func backButton(_ sender: UIButton){
          
          self.navigationController?.popViewController(animated: true)
                 
            }
}




                                      //*************** EXTENSION ******************


//********** IMAGEPICKER

extension SitterProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
     
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          
          
          
          if let  selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               
//               let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                       
                       sitterProfileImage.image = selectedImage
                       
                       
                       dismiss(animated: true, completion: nil)
               
               
          }
          
          
          if let selectedVideo = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
               
               print(selectedVideo.absoluteString)
               
               let saveFB = SaveVideoViewModel()
               
               saveFB.SaveVideoViewModel(Title: "MyVideo", selectedVideoUrl: selectedVideo) { (videoURL, status, err) in
                    
                    if status{
                         print(videoURL!)
                         
                         self.dbRef.collection("Users").document((sharedVariable.signInUser?.UserId)!).updateData(["VideoUrl":videoURL!])
                         
                         self.dismiss(animated: true, completion: nil)
                    }
                    else{
                         print(err!)
                         
                         let alert = UIAlertController(title: "Error", message: err!, preferredStyle: .alert)
                         alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                              
                               self.dismiss(animated: true, completion: nil)
                         }))
                    }
               }
               

               
               
               
               
          }
          
        
     }
     
}

