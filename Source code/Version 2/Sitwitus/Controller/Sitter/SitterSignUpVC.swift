//
//  SitterSignUpVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 28/01/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import LocationPickerViewController
import FirebaseAuth
import Firebase
import IQKeyboardManagerSwift


class SitterSignUpVC: UIViewController {


                                    //******** OUTLETS ***************
     @IBOutlet weak var sitterImage: UIImageView!
     @IBOutlet weak var nameTF: UITextField!
     @IBOutlet weak var emailTF: UITextField!
     @IBOutlet weak var passwordTF: UITextField!
     @IBOutlet weak var genderTF: UITextField!
     @IBOutlet weak var mobileTF: UITextField!
     @IBOutlet weak var LocationTF : UITextField!
     @IBOutlet weak var zipcodeTF: UITextField!
     @IBOutlet weak var rateTF: UITextField!
      @IBOutlet weak var signUpButton: UIButton!
      @IBOutlet weak var activity: UIActivityIndicatorView!


                                   //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
     
     var genderCatergory = ["","Male", "Female"]
     var selectedGender = ""
     var textfieldPickerView = UIPickerView()
     
     let alert = AlertWindow()
     let saveImageVM = SaveImageViewModel()
     var isImageAdded = false
     
     var selectedLat:Double = 0.0
     var selectedLong:Double = 0.0
     var setRate = 0.0
     
     
     var uploadVdoUrl = ""
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     activity.isHidden = true
     
     LocationTF.delegate = self
     genderTF.delegate = self
     rateTF.delegate = self
     textfieldPickerView.delegate = self
     
     let imageTap = UITapGestureRecognizer(target: self, action: #selector(addImageAction))
     sitterImage.addGestureRecognizer(imageTap)

     

     
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
     
     
     
     
     @IBAction func addVideoButtonAction(_ sender: Any) {
          
          
          rateTF.resignFirstResponder()
          
          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          
          imagePicker.sourceType = .photoLibrary
          imagePicker.mediaTypes = ["public.movie"]
          
          self.present(imagePicker, animated: true, completion: nil)
          
     }
     
//*********** SIGN UP
     @IBAction func signUpButtonAction(_ sender: Any) {
          
          activity.isHidden = false
          signUpButton.isUserInteractionEnabled = false
     
          if isImageAdded{
               
               
         
          
          if nameTF.text?.isEmpty == false && emailTF.text?.isEmpty == false && passwordTF.text?.isEmpty == false && genderTF.text?.isEmpty == false && mobileTF.text?.isEmpty == false && LocationTF.text?.isEmpty == false && rateTF.text?.isEmpty == false && zipcodeTF.text?.isEmpty == false{
           
                         
                      //************** Create User
                         Auth.auth().createUser(withEmail: self.emailTF.text!, password: self.passwordTF.text!) { (authResult, authError) in
                                           
                                           if authError == nil{
                                             
                                             self.saveImageVM.SaveImageViewModel(Title: "\(self.nameTF.text!)_Profile", selectedImage: self.sitterImage.image!) { (imageURL, Status, Err) in

                                                  if Status{
                                                       //********* CREATE DATABASE
                                                       let dbRef = Firestore.firestore()

                                                       let uploaDict = ["FullName":self.nameTF.text!,
                                                                        "Email":self.emailTF.text!,
                                                                        "Gender":self.genderTF.text!,
                                                                        "Mobile":self.mobileTF.text!,
                                                                        "Location":self.LocationTF.text!,
                                                                        "Rate":self.setRate,
                                                                        "Lat":self.selectedLat,
                                                                        "Long":self.selectedLong,
                                                                        "UserId":(authResult?.user.uid)!,
                                                                        "UserType":"Sitter",
                                                                        "VideoUrl":self.uploadVdoUrl,
                                                                        "ZipCode": self.zipcodeTF.text!,
                                                                        "ImageUrl":imageURL!] as [String : Any]



                                                       print(uploaDict)

                                                       
                                        dbRef.collection("Users").document((authResult?.user.uid)!).setData(uploaDict)
                                                       
                                   let successAlert = UIAlertController(title: "", message: "SUCCESS!", preferredStyle: .alert)
                                   successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                                                 
                                                       self.navigationController?.popViewController(animated: true)
                                                                            }))
                                                       
                                                       self.present(successAlert, animated: true, completion: nil)
                                                       
                                                  }

                                                  else{
                                                  self.alert.simple_Window(Title: "IMAGE UPLOAD ERROR", Message: Err!, View: self)
                                                       self.activity.isHidden = true
                                                       self.signUpButton.isUserInteractionEnabled = true
                                                                           }

                                             }
                                        
                                      }
                              
                                           else{
                                             self.alert.simple_Window(Title: "CREATE USER ERROR", Message: authError!.localizedDescription, View: self)
                                             self.activity.isHidden = true
                                             self.signUpButton.isUserInteractionEnabled = true
                                             }
//
               }
               
            
               
             
          }
         
          
          else{
               alert.simple_Window(Title: "TEXTFIELD EMPTY!", Message: "Please assure all required textfield is filled", View: self)
               activity.isHidden = true
                             signUpButton.isUserInteractionEnabled = true
          }
               
          
          }
                       
          
          
          else{
               alert.simple_Window(Title: "ADD IMAGE", Message: "Please add some image as your profile image", View: self)
               activity.isHidden = true
               signUpButton.isUserInteractionEnabled = true
                        }
          
     }
}




                                      //*************** EXTENSION ******************


//******** TEXTFIELD

extension SitterSignUpVC: UITextFieldDelegate{
     
     
     
     //--------------  BEGIN EDIT
     func textFieldDidBeginEditing(_ textField: UITextField) {
          
          if textField == LocationTF{
               
               LocationTF.resignFirstResponder()
               
               let locationPicker = LocationPicker()
               locationPicker.delegate = self
               
               
              let done = locationPicker.barButtonItems?.doneButtonItem
              let cancel = locationPicker.barButtonItems?.cancelButtonItem
               
               locationPicker.addBarButtons(doneButtonItem: done, cancelButtonItem: cancel, doneButtonOrientation: .right)
               
//               locationPicker.addBarButtons()
              
               locationPicker.pickCompletion = { (pickedLocationItem) in
                   
//                    print(pickedLocationItem.addressDictionary)
               }
               navigationController!.pushViewController(locationPicker, animated: true)
          }
          
          else if textField == genderTF{
               
               genderTF.inputView = textfieldPickerView
               
               
          }
          else if textField == rateTF{
               
               rateTF.clearsOnBeginEditing = true
          }
          else{
               textField.inputView = nil
          }
     }
     
     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
          
          
          
          if textField == rateTF{
               
               let value = rateTF.text!
               self.setRate = Double(value)!
               
               rateTF.text = "$ \(value)/hr"
               
          }
          
          return true
     }
     
}



//******** LOCATIONPICKER
extension SitterSignUpVC: LocationPickerDelegate{
    
     
     
     
     func locationDidPick(locationItem: LocationItem) {
          print("PICK")
     }
     
     
     func locationDidSelect(locationItem: LocationItem) {

          LocationTF.text = locationItem.name
          
          
          self.selectedLat = locationItem.coordinate!.latitude
                        self.selectedLong = locationItem.coordinate!.longitude
                        
                        print("lat\(self.selectedLat) & Long\(self.selectedLong)")
          
          
          
          let alertVC = UIAlertController(title: "Pin Drop", message: "Do you want to pin drop to exact location", preferredStyle: .alert)
          
          let Pin = UIAlertAction(title: "Pin Drop", style: .default, handler: nil)
          let Select = UIAlertAction(title: "Done", style: .default) { (action) in
               
               
               
               self.LocationTF.text = locationItem.name
               
               self.selectedLat = locationItem.coordinate!.latitude
               self.selectedLong = locationItem.coordinate!.longitude
               
               print("lat\(self.selectedLat) & Long\(self.selectedLong)")


               self.navigationController?.popViewController(animated: true)

          }
          
          alertVC.addAction(Pin)
          alertVC.addAction(Select)
          
          self.present(alertVC, animated: true, completion: nil)
     }
     
     
  
}

//******** PICKER VIEW
extension SitterSignUpVC : UIPickerViewDelegate, UIPickerViewDataSource{
    
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
          
          self.genderTF.text = genderCatergory[row]
          self.selectedGender = genderCatergory[row]
     }
     
     
}



//********** IMAGEPICKER

extension SitterSignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
     
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          
          
          
          if let  selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               
//               let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                       
                       sitterImage.image = selectedImage
                       
                       self.isImageAdded = true
                       
                       dismiss(animated: true, completion: nil)
               
               
          }
          
          
          if let selectedVideo = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
               
               print(selectedVideo.absoluteString)
               
               let saveFB = SaveVideoViewModel()
               
               saveFB.SaveVideoViewModel(Title: "MyVideo", selectedVideoUrl: selectedVideo) { (videoURL, status, err) in
                    
                    if status{
                         print(videoURL!)
                         
                         self.uploadVdoUrl = videoURL!
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


