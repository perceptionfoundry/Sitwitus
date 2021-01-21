//
//  SignInVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 03/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import CodableFirebase


var sharedVariable = UIApplication.shared.delegate as! AppDelegate

class SignInVC: UIViewController {


                                    //******** OUTLETS ***************
     @IBOutlet weak var emailTF: UITextField!
     @IBOutlet weak var passwordTF: UITextField!


                                   //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
         
     var alert = AlertWindow()
     
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }



                                    //*************** OUTLET ACTION ******************
     
     //****** BACK
     @IBAction func backButtonAction(){
          
          self.navigationController?.popViewController(animated: true)
     }
     
     //******  LOGIN
     @IBAction func loginButtonAction(){
          
          

//
//
          //******* CHECK TEXTFIELD
          if emailTF.text?.isEmpty == false && passwordTF.text?.isEmpty == false{

               Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { (authResult, authErr) in
                    
                    if authErr == nil{
                         
                        
                         
                         let dbRef = Firestore.firestore()
                         
                         dbRef.collection("Users").document((authResult?.user.uid)!).getDocument { (docSnap, docErr) in
                              
                              guard let fetchData = docSnap?.data() else{return}
                              
                              
                              //************** CREATE SIGN IN USER DETAIL GLOBAL TO APP
                              
                              let value = try! FirestoreDecoder().decode(Users.self, from: fetchData)
                              
                              
                              
                              var userInfo = Users.userDetail
                              
                              userInfo = value
                              
                              sharedVariable.signInUser = userInfo
                              
                              
                              
                              
                        //************ USER DEFAULT TO MANAGE AUTO SIGN IN
                              UserDefaults.standard.set(fetchData, forKey: "SIGN_DETAIL")
                              UserDefaults.standard.set(true, forKey: "SIGNIN")
                              self.performSegue(withIdentifier: "Login_Segue", sender: nil)
                         }
                         
                     
                         
                         
//
                    }
                    else{
                         self.alert.simple_Window(Title: "Auth Error", Message: (authErr?.localizedDescription)!, View: self)
                    }
               }


          }else{

               alert.simple_Window(Title: "TEXTFIELD EMPTY!", Message: "Please assure all required textfield is filled", View: self)

          }
          
          
          
          
          
     }

}




                                      //*************** EXTENSION ******************
