//
//  SitterSideMenuVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 31/01/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class SitterSideMenuVC: UIViewController {


                                    //******** OUTLETS ***************

     @IBOutlet weak var sideView: UIView!
     

                                   //******** VARIABLES *************
     
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

     let swipe = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
     swipe.direction = .left
     view.addGestureRecognizer(swipe)
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

     
     
     
  
     
//***** BACK
     
     @objc func backAction(){
          self.dismiss(animated: true, completion: nil)

     }


                                    //*************** OUTLET ACTION ******************
     
     @IBAction func attendanceButton(){
          
          
//          self.dismiss(animated: true, completion: nil)
//          let vc = UIStoryboard(name: "Sitter", bundle: nil).instantiateViewController(identifier: "attendance") as! SitterAttendancePopVC
//          
//          self.present(vc, animated: true, completion: nil)
       
        
     }
     
          @IBAction func familyButton(){
               let vc = UIStoryboard(name: "Sitter", bundle: nil).instantiateViewController(identifier: "ParentList")
               
               self.navigationController?.pushViewController(vc, animated: true)
          }
     
     
     @IBAction func contactButtonAction(){
               let mailComposerVC = configureMailComposerViewController()
          
          if MFMailComposeViewController.canSendMail(){
               self.present(mailComposerVC, animated: true, completion: nil)
          }
          else{
               self.showSendMailErrorAlert()
          }
     
     }
     
     @IBAction func logoutButton(){
                   
          let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FIRST")
          UserDefaults.standard.set(false, forKey: "SIGNIN")
          UserDefaults.standard.set(nil, forKey: "SIGN_DETAIL")
          
          self.navigationController?.pushViewController(firstVC, animated: true)
              }
     
     
//     FIRST

}




                                      //*************** EXTENSION ******************
extension SitterSideMenuVC: MFMailComposeViewControllerDelegate{
     
     
     func configureMailComposerViewController() -> MFMailComposeViewController{
          
          let mailcomposerVC = MFMailComposeViewController()
          mailcomposerVC.mailComposeDelegate = self
          mailcomposerVC.setToRecipients(["info@sitwitus.com"])
          
          mailcomposerVC.setSubject("")
          mailcomposerVC.setMessageBody("", isHTML: false)
          
          return mailcomposerVC
     }
     
     func showSendMailErrorAlert(){
            
          let errAlert = UIAlertController(title: "Could not send mail", message: "Your device must be have active mail account", preferredStyle: .alert)
          
          errAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(errAlert, animated: true, completion: nil)
       }
     
     
     func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
          controller.dismiss(animated: true, completion: nil)
     }
}
