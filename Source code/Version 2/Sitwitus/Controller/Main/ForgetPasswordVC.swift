//
//  ForgetPasswordVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 08/03/2021.
//  Copyright © 2021 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase

class ForgetPasswordVC: UIViewController {

     @IBOutlet weak var emailTF : UITextField!
     
     
     let alert = AlertWindow()
     
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

     @IBAction func backAction(){
          self.dismiss(animated: true, completion: nil)
     }
     @IBAction func SubmitAction(){
          
          
          guard let email = emailTF.text  else{return}
          Auth.auth().sendPasswordReset(withEmail: email) { (err) in
               
               if err == nil{
                    self.alert.simple_Window(Title: "Success to Reset Password", Message: "Please check mail inbox for reset process", View: self)
               }else{
                    
                    self.alert.simple_Window(Title: "Error!", Message: err!.localizedDescription, View: self)
               }
          }
     }


}
