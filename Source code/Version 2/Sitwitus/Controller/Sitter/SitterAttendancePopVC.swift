//
//  SitterAttendancePopVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 25/01/2021.
//  Copyright © 2021 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class SitterAttendancePopVC: UIViewController {
     
     
     //******** OUTLETS ***************

     @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
     @IBOutlet weak var popView: Custom_View!
     @IBOutlet weak var checkTitle: UILabel!
     @IBOutlet weak var elapseTime: UILabel!
     @IBOutlet weak var checkButton: Custom_Button!
     

    //******** VARIABLES *************

    
    //********* FUNCTIONS ***************


//******* VIEW FUNCTIONS

override func viewDidLoad() {
super.viewDidLoad()


}

override func viewWillAppear(_ animated: Bool) {
super.viewWillAppear(animated)
     self.bottomConstraint.constant = -150
     
     let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
     
     view.addGestureRecognizer(tap)
  
     UIView.animate(withDuration: 3, delay: 500, options: .curveEaseIn) {
                    self.bottomConstraint.constant += 150
               }
 
     
}

     @objc func dismissAction(){
          
          
          UIView.animate(withDuration: 3, delay: 500, options: .curveEaseOut) {
                    self.bottomConstraint.constant -= 150
               } completion: { (status) in
                    
                    if status{
                         self.dismiss(animated: true, completion: nil)
                    }
               }
          
     }

     //*************** OUTLET ACTION ******************

     @IBAction func CheckButtonAction(_ sender: Any) {
          
          UIView.animate(withDuration: 3, delay: 0.5, options: .curveEaseOut) {
                    self.bottomConstraint.constant -= 150
               } completion: { (status) in
                    
                    if status{
                         self.dismiss(animated: true, completion: nil)
                    }
               }
          
     }
     
     @IBAction func smsButtonAction(_ sender: Any) {
     }
     @IBAction func emergencyButtonAction(_ sender: Any) {
     }
}




       //*************** EXTENSION ******************
