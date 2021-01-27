//
//  CheckOutVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 27/01/2021.
//  Copyright © 2021 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class CheckOutVC: UIViewController {
     
     override func viewDidLoad() {
         super.viewDidLoad()

         // Do any additional setup after loading the view.
     }
     
     
     
     func getDateDiff(start: Date, end: Date) -> Int  {
         let calendar = Calendar.current
         let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)

         let seconds = dateComponents.second
         return Int(seconds!)
     }

//     let t1 = 1611875400
//     let t2 = 1611859500
//
//     let start = Date(timeIntervalSince1970: TimeInterval(t2))
//     let end = Date(timeIntervalSince1970: TimeInterval(t1))
//
//
//
//
//     let second = getDateDiff(start: end, end: start)
//
//     print("\(Float(second/3600))")

      
      
      @IBAction func continueButton(){
                      let story = UIStoryboard(name: "Sitter", bundle: nil)
                      let vc = story.instantiateViewController(withIdentifier: "SITTER_MAIN")
                      
//          self.present(vc, animated: true, completion: nil)
                      self.navigationController?.pushViewController(vc, animated: true)
                  
             }

  

 }
