//
//  ConfirmVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 10/03/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class ConfirmVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
     
     
     @IBAction func continueButton(){
                     let story = UIStoryboard(name: "Parent", bundle: nil)
                     let vc = story.instantiateViewController(withIdentifier: "MAIN")
                     
                     self.navigationController?.pushViewController(vc, animated: true)
                 
            }

 

}
