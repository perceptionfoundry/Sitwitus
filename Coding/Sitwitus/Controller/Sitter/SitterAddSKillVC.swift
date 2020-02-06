//
//  SitterAddSKillVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 06/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import TagListView


class SitterAddSKillVC: UIViewController {


                                    //******** OUTLETS ***************
     @IBOutlet weak var addTitle: UILabel!

     @IBOutlet weak var addTF: UITextField!
     @IBOutlet weak var addTag: TagListView!


                                   //******** VARIABLES *************

     var placeHolderTitle = ""
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     self.addTitle.text = "Add \(placeHolderTitle)"
     self.addTF.placeholder = placeHolderTitle.lowercased()
    }



                                    //*************** OUTLET ACTION ******************

     @IBAction func addButton(_ sender: UIButton){
                  
          addTag.addTag(addTF.text!)
          addTF.text = ""
              }
     
     @IBAction func submitButton(_ sender: UIButton){
          self.dismiss(animated: true, completion: nil)
           }
}




                                      //*************** EXTENSION ******************
