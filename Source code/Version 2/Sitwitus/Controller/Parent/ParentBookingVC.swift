//
//  ParentBookingVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 12/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import HCSStarRatingView
import SDWebImage
import Firebase




class ParentBookingVC: UIViewController {
   
     
    


                                    //******** OUTLETS ***************

     @IBOutlet weak var sitterName: UILabel!
     @IBOutlet weak var sitterImage: Custom_ImageView!
     @IBOutlet weak var sitterSkill: UILabel!
     @IBOutlet weak var sitterSpecialist: UILabel!
     @IBOutlet weak var timeTF: UITextField!
     @IBOutlet weak var dateTF: UITextField!
     @IBOutlet weak var rateLabel: UILabel!
     @IBOutlet weak var rateStars: HCSStarRatingView!
     @IBOutlet weak var tipLabel: UILabel!
     @IBOutlet weak var tipAmount: UILabel!
     @IBOutlet weak var hours: UITextField!
     @IBOutlet var tipButton: [UIButton]!
     
     
      @IBOutlet var ButtonLabel0: UILabel!
      @IBOutlet var ButtonLabel1: UILabel!
      @IBOutlet var ButtonLabel2: UILabel!
      @IBOutlet var ButtonLabel3: UILabel!
     
     @IBOutlet var ButtonView0: Custom_View!
     @IBOutlet var ButtonView1: Custom_View!
     @IBOutlet var ButtonView2: Custom_View!
     @IBOutlet var ButtonView3: Custom_View!
     
     
     

                                   //******** VARIABLES *************
     var sitter : Users!
     var dbStore = Firestore.firestore()
     var tipPercent = 10
     let datePicker = UIDatePicker()
     var date = Date()
     var time_combine  = ""
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

     
     
        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     sitterName.text = sitter.FullName
     sitterImage.sd_setImage(with: URL(string: sitter.ImageUrl), placeholderImage: UIImage(named: "profile_Image"), options: .progressiveLoad, completed: nil)
     
     rateLabel.text = "Rate \(sitter.FullName!)"
     tipLabel.text = "Would you like to tip \(sitter.FullName!)"
     
     
     
     //******* SKILL
     dbStore.collection("Users").document(sitter.UserId).collection("Profile").document("Skill").getDocument { (snapResult, snapErr) in
          
          guard let fetchdata = snapResult?.data()  else{return}
          
         
          
          let skill = fetchdata["Value"] as! [String]
          
          self.sitterSkill.text =  skill.joined(separator: ",")
          self.sitterSkill.textColor = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
     }
     
     
     //******* SPECIALIST
     dbStore.collection("Users").document(sitter.UserId).collection("Profile").document("Specialist").getDocument { (snapResult, snapErr) in
          
          guard let fetchdata = snapResult?.data()  else{return}
          
          
          
          let Specialist = fetchdata["Value"] as! [String]
          
          self.sitterSpecialist.text =  Specialist.joined(separator: ",")
          self.sitterSpecialist.textColor = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
     }
     
     
     rateStars.value = CGFloat(sitter.Star ?? 1.0)
     
     tipAmount.text = "$ \(sitter.Rate!)0"
     
     timeTF.delegate = self
     dateTF.delegate = self
     
     if #available(iOS 13.4, *) {
         datePicker.preferredDatePickerStyle = .wheels
     } else {
         // Fallback on earlier versions
     }
    }

     // ******************* SHOW DATE FUNCTION
     
     
     func showDatePicker(){
         
         datePicker.minimumDate = Date()
         datePicker.datePickerMode = .date
         
         
         //ToolBar
         let toolbar = UIToolbar();
         toolbar.sizeToFit()
         let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
         let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
         
         toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
         
         dateTF.inputAccessoryView = toolbar
         dateTF.inputView = datePicker
         
     }
     
     @objc func donedatePicker(){
         
         
         let formatter = DateFormatter()
         formatter.dateFormat = "dd/MMM/yyyy"
         formatter.dateStyle = .medium
         date = datePicker.date
         
         
         
         dateTF.text = formatter.string(from: datePicker.date)

//         formatter.dateFormat = "MMMM dd, yyyy"
//         self.date_combine = formatter.string(from: datePicker.date)
         self.view.endEditing(true)
     }
     
     @objc func cancelDatePicker(){
         self.view.endEditing(true)
     }
     
     
     // ******************* SHOW TIME FUNCTION
     
     
      func showTimePicker(){
         //Formate Date
         datePicker.datePickerMode = .time
        
     
         
         //ToolBar
         let toolbar = UIToolbar();
         toolbar.sizeToFit()
         let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker));
         let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTimePicker));
         
         toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
         
         timeTF.inputAccessoryView = toolbar
         timeTF.inputView = datePicker
         
     }
     
     @objc func doneTimePicker(){
         
         let formatter = DateFormatter()
         formatter.dateFormat = "h:mm a"
         
         date = datePicker.date
     
         timeTF.text = formatter.string(from: datePicker.date)
//         formatter.dateFormat = "h:mm"
//         self.time_combine = formatter.string(from: datePicker.date)

         
         self.view.endEditing(true)
     }
     
     @objc func cancelTimePicker(){
         self.view.endEditing(true)
     }


                                    //*************** OUTLET ACTION ******************

     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
     }
     
     
     @IBAction func tipButtonAction(_  button : UIButton){
          
          let tag = button.tag
          
          
          tipButton.forEach { (button) in
          
               button.setTitleColor(.black, for: .normal)
               
          }
          
          ButtonView0.backgroundColor = UIColor(red: 0.877, green: 0.877, blue: 0.877, alpha: 1)
          ButtonView1.backgroundColor = UIColor(red: 0.877, green: 0.877, blue: 0.877, alpha: 1)
          ButtonView2.backgroundColor = UIColor(red: 0.877, green: 0.877, blue: 0.877, alpha: 1)
          ButtonView3.backgroundColor = UIColor(red: 0.877, green: 0.877, blue: 0.877, alpha: 1)
          
          ButtonView0.border_color = .clear
          ButtonView1.border_color = .clear
          ButtonView2.border_color = .clear
          ButtonView3.border_color = .clear
          
          ButtonLabel0.textColor = .black
          ButtonLabel1.textColor = .black
          ButtonLabel2.textColor = .black
          ButtonLabel3.textColor = .black
          //0.875 gray
          
//          button.setTitleColor(UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1), for: .normal)
          
          
          if tag == 0{
               ButtonView0.backgroundColor = .white
               ButtonView0.border_color = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
               ButtonLabel0.textColor = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
               self.tipPercent = 5

          }
          
          else if tag == 1{
               ButtonView1.backgroundColor = .white
               ButtonView1.border_color = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
               ButtonLabel1.textColor = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
               self.tipPercent = 10
               
          }
          
          else if tag == 2{
               ButtonView2.backgroundColor = .white
               ButtonView2.border_color = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
               ButtonLabel2.textColor = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
               self.tipPercent = 15

          }
          
          else if tag == 3{
               ButtonView3.backgroundColor = .white
               ButtonView3.border_color = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
               ButtonLabel3.textColor = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
               self.tipPercent = 20

          }

          //0.369   0.737    0.753
         }
     
     @IBAction func bookingButton(){
          

          if hours.text?.isEmpty == false && timeTF.text?.isEmpty == false{
          let dict = [
               "CreatedBy": (sharedVariable.signInUser?.UserId)!,
               "Address": (sharedVariable.signInUser?.Location)!,
               "Lat":(sharedVariable.signInUser?.Lat)!,
               "Long": (sharedVariable.signInUser?.Long)!,
               "ParentName": (sharedVariable.signInUser?.FullName)!,
               "ParentUid":(sharedVariable.signInUser?.UserId)!,
               "ParentImage":(sharedVariable.signInUser?.ImageUrl)!,
               "SitterName":(sitter.FullName)!,
               "SitterUid":(sitter.UserId)!,
               "SitterReview": Double(rateStars.value),
               "SitterImage":(sitter.ImageUrl)!,
               "Rate":sitter.Rate!,
               "Tip": self.tipPercent,
               "Date": self.dateTF.text!,
               "Time": self.timeTF.text!,
               "Hours": (self.hours.text)!,
               "Status": "Requested"] as [String : Any]
               
               
               sharedVariable.tempDict = dict
               
               
               performSegue(withIdentifier: "FINAL", sender: dict)
          
          
         
          }else{
               let alert = AlertWindow()
               
               alert.simple_Window(Title: "HOURS REQUIRED", Message: "Please tell number of required", View: self)
          }
     }
     
   
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
          let dest = segue.destination  as! ParentBookingReviewVC
          
          dest.bookingDict = sender as! [String:Any]
     }


}




                                      //*************** EXTENSION ******************

extension ParentBookingVC : UITextFieldDelegate{
     
     func textFieldDidBeginEditing(_ textField: UITextField) {
         
          if textField == self.dateTF{
              self.showDatePicker()

          }
          else if textField == self.timeTF{
             self.showTimePicker()
         }
         else{
             
         }
     }
}




