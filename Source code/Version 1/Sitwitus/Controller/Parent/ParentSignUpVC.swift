//
//  ParentSignUpVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 10/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import LocationPickerViewController
import FirebaseAuth
import Firebase
import IQKeyboardManagerSwift

class ParentSignUpVC: UIViewController {


                                    //******** OUTLETS ***************
     @IBOutlet weak var parentImage: UIImageView!
     @IBOutlet weak var nameTF: UITextField!
     @IBOutlet weak var emailTF: UITextField!
     @IBOutlet weak var passwordTF: UITextField!
     @IBOutlet weak var parentalTypeTF: UITextField!
     @IBOutlet weak var mobileTF: UITextField!
     @IBOutlet weak var LocationTF : UITextField!
     @IBOutlet weak var zipcodeTF: UITextField!
      @IBOutlet weak var activity: UIActivityIndicatorView!


                                   //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
     
     var genderCatergory = ["","Father", "Mother", "Guardian"]
     var selectedGender = ""
     var textfieldPickerView = UIPickerView()
     
     let alert = AlertWindow()
     let saveImageVM = SaveImageViewModel()
     var isImageAdded = false
     
     var selectedLat:Double = 0.0
     var selectedLong:Double = 0.0
     var setRate = 0.0
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     activity.isHidden = true
     
     emailTF.delegate = self
     parentalTypeTF.delegate = self
     textfieldPickerView.delegate = self
     
     let imageTap = UITapGestureRecognizer(target: self, action: #selector(addImageAction))
     parentImage.addGestureRecognizer(imageTap)

     

     
     }

     
     
     //********** ADD IMAGE ON TAP ACTION
     
     @objc func addImageAction(){
          
          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          
          //------ GALLERY
          
          let selectionVC = UIAlertController(title: "CHOOSE SOURCE", message: "Please desire source to get image", preferredStyle: .actionSheet)
          
          let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
               
               imagePicker.sourceType = .photoLibrary
               
               self.present(imagePicker, animated: true, completion: nil)
               
          }
          
          let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
               
               imagePicker.sourceType = .camera
               self.present(imagePicker, animated: true, completion: nil)

          }
          
          let cancel = UIAlertAction(title: "Cancel", style: .destructive)
          
          selectionVC.addAction(gallery)
          selectionVC.addAction(camera)
          selectionVC.addAction(cancel)
          
          self.present(selectionVC, animated: true, completion: nil)
          
     
     }
     
     
     
    


                                    //*************** OUTLET ACTION ******************

     
     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
     }
     
  
     
//*********** SIGN UP
     @IBAction func continueButtonAction(_ sender: Any) {
          
        
     
          if isImageAdded{
               
               
         
          
               if nameTF.text?.isEmpty == false && emailTF.text?.isEmpty == false && passwordTF.text?.isEmpty == false && parentalTypeTF.text?.isEmpty == false && mobileTF.text?.isEmpty == false && LocationTF.text?.isEmpty == false &&  zipcodeTF.text?.isEmpty == false{
                    
                    
                    let personalDict = ["FullName":self.nameTF.text!,
                    "Email":self.emailTF.text!,
                    "Gender":self.parentalTypeTF.text!,
                    "Mobile":self.mobileTF.text!,
                    "Location":self.LocationTF.text!,
                    "Lat":self.selectedLat,
                    "Long":self.selectedLong,
                    "UserType":"Parent",
                    "ZipCode": self.zipcodeTF.text!] as [String : Any]
                    
                    performSegue(withIdentifier: "NEXT", sender: personalDict)
               }
         
          
          else{
               alert.simple_Window(Title: "TEXTFIELD EMPTY!", Message: "Please assure all required textfield is filled", View: self)
               activity.isHidden = true
                        
          }
               
          
          }
                       
          
          
          else{
               alert.simple_Window(Title: "ADD IMAGE", Message: "Please add some image as your profile image", View: self)
            
                        }
          
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
          let dest = segue.destination as! ParentSignUpReasonVC
          
          
          dest.uploadDict = sender as! [String : Any]
          dest.parentDP = self.parentImage.image!
          dest.signUpName = self.nameTF.text!
          dest.signUpEmail = self.emailTF.text!
          dest.signUpPassword = self.passwordTF.text!
     }
}




                                      //*************** EXTENSION ******************


//******** TEXTFIELD

extension ParentSignUpVC: UITextFieldDelegate{
     
     
     
     //************** PERSONALIZE FUNCTION ****************
          
          func validate(YourEMailAddress: String) -> Bool {
                 let REGEX: String
                 REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
                 return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
             }
     
     
     //--------------  BEGIN EDIT
     func textFieldDidBeginEditing(_ textField: UITextField) {
          
//  
          
           if textField == parentalTypeTF{
               
               parentalTypeTF.inputView = textfieldPickerView
               
               
          }
          else{
               textField.inputView = nil
          }
     }
     
     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
 
          return true
     }
     
 
          
          
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

      
      
      
      if textField == emailTF{
                  
                  if self.validate(YourEMailAddress: emailTF.text!){
                      
                      emailTF.textColor = .black
                  }
                  else{
                      emailTF.textColor = .red

                  }
              }

              return true
     }
     
     
     
     
}



//******** PICKER VIEW
extension ParentSignUpVC : UIPickerViewDelegate, UIPickerViewDataSource{
    
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          
          return genderCatergory.count
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          
          return genderCatergory[row]
     }
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          
          self.parentalTypeTF.text = genderCatergory[row]
          self.selectedGender = genderCatergory[row]
     }
     
     
}


//********** IMAGEPICKER

extension ParentSignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
     
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          
          let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
          
          parentImage.image = selectedImage
          
          self.isImageAdded = true
          
          dismiss(animated: true, completion: nil)
     }
     
}




