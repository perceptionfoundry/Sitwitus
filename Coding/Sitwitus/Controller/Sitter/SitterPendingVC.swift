//
//  SitterPendingVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 31/01/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class SitterPendingVC: UIViewController {


                                    //******** OUTLETS ***************

     @IBOutlet weak var pendingTable : UITableView!

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
     
     pendingTable.delegate = self
     pendingTable.dataSource = self
     pendingTable.reloadData()
    }



                                    //*************** OUTLET ACTION ******************

     @IBAction func backButton(){
//          self.navigationController?.popViewController(animated: true)
          self.dismiss(animated: true, completion: nil)
     }
}




                                      //*************** EXTENSION ******************

extension SitterPendingVC: UITableViewDelegate, UITableViewDataSource{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 3
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "PENDING", for: indexPath)
          
          return cell
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 150
     }
}
