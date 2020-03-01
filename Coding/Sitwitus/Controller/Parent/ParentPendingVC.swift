//
//  ParentPendingVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 12/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class ParentPendingVC:  UIViewController {


                                    //******** OUTLETS ***************

     @IBOutlet weak var pendingTable : UITableView!

                                   //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
        
     
     let dbStore = Firestore.firestore()
  
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
     
     self.getData()
    }

     
     
     func getData(){
          
          let currentUser = sharedVariable.signInUser
          
          self.dbStore.collection("Requests").whereField("ParentUid", isEqualTo: (currentUser?.UserId)!).order(by: "Timestamp").getDocuments { (requestSnap, requestErr) in
               
//               guard let fetchData = requestSnap?.documents else{return}
               
//               print(fetchData.first?.data())
          }
          
          
          
     }
     
     @objc func acceptButtonAction (button : UIButton){
              
              
              print("ACCEPT")
              
         }
     
     @objc func declineButtonAction (button : UIButton){
          
          print("DECLINE")

          
          
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

extension ParentPendingVC: UITableViewDelegate, UITableViewDataSource{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 3
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "PENDING", for: indexPath) as! ParentPendingTableViewCell
          
        
          
          cell.acceptButton.tag = indexPath.row
     cell.acceptButton.addTarget(self, action: #selector(acceptButtonAction), for: .touchUpInside)
         
          cell.pendingButton.tag = indexPath.row
          cell.pendingButton.addTarget(self, action: #selector(declineButtonAction), for: .touchUpInside)
          
          cell.messageButton.tag = indexPath.row

          return cell
     }
     
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
   
          
     }
     
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 150
        }
}
