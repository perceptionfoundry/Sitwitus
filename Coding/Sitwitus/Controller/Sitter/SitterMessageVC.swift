//
//  SitterMessageVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 03/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class SitterMessageVC: UIViewController
{


                                    //******** OUTLETS ***************

     @IBOutlet weak var messageTable: UITableView!
      @IBOutlet weak var messageTF: UITextField!

                                   //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     let sender_Nib = UINib(nibName: "SenderTableViewCell", bundle: nil)
     messageTable.register(sender_Nib, forCellReuseIdentifier: "SENDER")
     
     let receiver_Nib = UINib(nibName: "RecieverTableViewCell", bundle: nil)
     messageTable.register(receiver_Nib, forCellReuseIdentifier: "RECEIVER")
     
     let time_Nib = UINib(nibName: "TImeTableViewCell", bundle: nil)
     messageTable.register(time_Nib, forCellReuseIdentifier: "TIME")
     
     messageTable.delegate = self
     messageTable.dataSource = self
     messageTable.reloadData()
    }



                                    //*************** OUTLET ACTION ******************

         @IBAction func backButton(){
               self.navigationController?.popViewController(animated: true)
          }
}




                                      //*************** EXTENSION ******************

extension SitterMessageVC: UITableViewDataSource, UITableViewDelegate{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 5
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TIME", for: indexPath)
               
               return cell
          }
          
          else if indexPath.row == 1 || indexPath.row == 3{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SENDER", for: indexPath)
               
               return cell
          }
        
          
          else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "RECEIVER", for: indexPath)
               
               return cell

          }
          
     }
     
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 80
     }
}
