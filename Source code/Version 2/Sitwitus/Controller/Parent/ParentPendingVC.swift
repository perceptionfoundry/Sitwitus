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
import SDWebImage

class ParentPendingVC:  UIViewController {


                                    //******** OUTLETS ***************

     @IBOutlet weak var pendingTable : UITableView!

                                   //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
        
     
     let dbStore = Firestore.firestore()
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
     
     self.getData()
    }

     
     
     func getData(){
          
          pendingList.removeAll()
          pendingTable.reloadData()
          
          let currentUser = sharedVariable.signInUser
          
          self.dbStore.collection("Requests").whereField("ParentUid", isEqualTo: (currentUser?.UserId)!).order(by: "Timestamp").getDocuments { (requestSnap, requestErr) in
               
               guard let fetchData = requestSnap?.documents else{return}
               
               
               
               fetchData.forEach { (VALUE) in
                    
                    let pendingValue = try! FirestoreDecoder().decode(Pending.self, from: VALUE.data())
                    
                    self.pendingList.append(pendingValue)
                    self.pendingTable.reloadData()
               }
               
          }
          
          
          
     }
     
     @objc func acceptButtonAction (button : UIButton){
              
              
              print("ACCEPT")
          dbStore.collection("Requests").document((pendingList[button.tag].requestUid)!).updateData(["Status":"Accepted"])

              
         }
     
     @objc func declineButtonAction (button : UIButton){
          
          print("DECLINE")
          

          dbStore.collection("Requests").document((pendingList[button.tag].requestUid)!).updateData(["Status":"Declined"])
          
     }
     
     @objc func messageButtonAction (button : UIButton){
              print("Message")
          
          let sender = (sharedVariable.signInUser?.UserId)!
          let reciever = (pendingList[button.tag].SitterUid)!
          
          let vc = UIStoryboard(name: "Parent", bundle: nil).instantiateViewController(identifier: "CHAT") as! ParentInboxVC
          
         
          vc.receiverID = reciever
          
          self.navigationController?.pushViewController(vc, animated: true)
         }


                                    //*************** OUTLET ACTION ******************

     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
          
     }
}




                                      //*************** EXTENSION ******************

extension ParentPendingVC: UITableViewDelegate, UITableViewDataSource{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return pendingList.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "PENDING", for: indexPath) as! ParentPendingTableViewCell
          
          cell.sitterName.text = pendingList[indexPath.row].SitterName
          cell.sitterAddress.text = pendingList[indexPath.row].Address
          cell.sitterImage.sd_setImage(with: URL(string: pendingList[indexPath.row].SitterImage), placeholderImage: UIImage(named: "new_image"), options: .progressiveLoad, completed: nil)
          cell.sitterRate.text = "$\((pendingList[indexPath.row].Rate)!)"
          cell.ratingStar.value = CGFloat(pendingList[indexPath.row].SitterReview)
          cell.pendingHours.text = "Required for \((pendingList[indexPath.row].Hours)!) Hours"
          
          
          if pendingList[indexPath.row].CreatedBy == (sharedVariable.signInUser?.UserId)!{
               cell.acceptButton.isHidden = true
          }
          else{
          cell.acceptButton.tag = indexPath.row
          cell.acceptButton.addTarget(self, action: #selector(acceptButtonAction), for: .touchUpInside)
          }
          cell.pendingButton.tag = indexPath.row
          cell.pendingButton.addTarget(self, action: #selector(declineButtonAction), for: .touchUpInside)
          
          cell.messageButton.tag = indexPath.row
          cell.messageButton.addTarget(self, action: #selector(messageButtonAction), for: .touchUpInside)


          return cell
     }
     
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
   
          
     }
     
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 150
        }
}
