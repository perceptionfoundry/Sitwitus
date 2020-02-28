//
//  SitterPendingVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 31/01/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase

class SitterPendingVC: UIViewController {


                                    //******** OUTLETS ***************

     @IBOutlet weak var pendingTable : UITableView!

                                   //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
        
     var selectedIndex = -1
     var rejectRequest = [Int]()
     var acceptedRequest = [Int]()
     
     var dbStore = Firestore.firestore()
     var pendingList = [Pending]()
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

     
     func getdata(){
          
          
     }
     
     @objc func requestButtonAction (button : UIButton){
          
          self.selectedIndex = button.tag
          
          let alertVC = UIAlertController(title: "Request Action", message: "Choose your desire action", preferredStyle: .actionSheet)
          
          let Accept = UIAlertAction(title: "Accept", style: .default) { (action) in
               self.acceptedRequest.append(self.selectedIndex)
               self.pendingTable.reloadData()
          }
          
          let reject = UIAlertAction(title: "Reject", style: .destructive) { (action) in
               self.rejectRequest.append(self.selectedIndex)
               self.pendingTable.reloadData()
          }
          
          
          let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          
          alertVC.addAction(Accept)
          alertVC.addAction(reject)
          alertVC.addAction(cancel)
          
          self.present(alertVC, animated: true, completion: nil)
          
     }
     
     @objc func messageButtonAction (button : UIButton){
              print("Message")
         }


                                    //*************** OUTLET ACTION ******************

     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
          
     }
}




                                      //*************** EXTENSION ******************

extension SitterPendingVC: UITableViewDelegate, UITableViewDataSource{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 3
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "PENDING", for: indexPath) as! PendingTableViewCell
          
          if rejectRequest.contains(indexPath.row){
               cell.pendingButton.backgroundColor = .red
               cell.pendingButton.setTitle("Rejected", for: .normal)

          }
          
          if acceptedRequest.contains(indexPath.row){
               cell.pendingButton.setTitle("Accepted", for: .normal)
          }
         
          cell.pendingButton.tag = indexPath.row
          cell.pendingButton.addTarget(self, action: #selector(requestButtonAction), for: .touchUpInside)
          
          cell.messageButton.tag = indexPath.row

          return cell
     }
     
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
   
          
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 150
     }
}
