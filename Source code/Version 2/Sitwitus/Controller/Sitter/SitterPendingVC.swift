//
//  SitterPendingVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 31/01/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import SDWebImage

class SitterPendingVC: UIViewController {


                                    //******** OUTLETS ***************

     @IBOutlet weak var pendingTable : UITableView!

                                   //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
        
     
     let dbStore = Firestore.firestore()
     var pendingList = [Request]()
  
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

     
     //MARK: GET DATA
     func getData(){
          
          pendingList.removeAll()
          pendingTable.reloadData()
          
          let currentUser = sharedVariable.signInUser
          
          self.dbStore.collection("Requests").whereField("SitterUid", isEqualTo: (currentUser?.UserId)!).order(by: "Timestamp").getDocuments { (requestSnap, requestErr) in
               
               guard let fetchData = requestSnap?.documents else{return}
               
               
               
               fetchData.forEach { (VALUE) in
                    
                    let pendingValue = try! FirestoreDecoder().decode(Request.self, from: VALUE.data())
                    
                    if pendingValue.Status == "Requested" && pendingValue.CreatedBy != currentUser?.UserId{
                    self.pendingList.append(pendingValue)
                    self.pendingTable.reloadData()
                    }
               }
               
          }
          
          
          
     }
     
     @objc func pendingButtonAction (button : UIButton){
              
          
          
          let actionSheetView = UIAlertController(title: "RESPOND ACTION", message: "What would you like to do ?", preferredStyle:.actionSheet)
          
          let acceptAction  = UIAlertAction(title: "Accept", style: .default) { (action) in
               
               
               let info = self.pendingList[button.tag]
               print("ACCEPT")
               self.dbStore.collection("Requests").document((info.requestUid)!).updateData(["Status":"Accepted"])
            
               let appointId = randomString(length: 6)
               
            
               
            
               let dict = ["appointmentId": appointId,
                           "CreatedBy": info.CreatedBy!,
                           "Address": info.Address,
                           "Lat": info.Lat,
                           "Long": info.Long,
                           "ParentName": info.ParentName!,
                           "ParentUid": info.ParentUid!,
                           "ParentImage": info.ParentImage!,
                           "SitterName": info.SitterName!,
                           "SitterUid": info.SitterUid!,
                           "SitterImage": info.SitterImage!,
                           "SitterReview": info.SitterReview!,
                           "Rate": info.Rate!,
                           "Tip": info.Tip!,
                           "Hours": info.Hours!,
                           "Date": info.Date!,
                           "Time": info.Time!,
                           "Status": "Accepted",
                           "Timestamp": info.Timestamp!,
                           "requestUid": info.requestUid!] as [String : Any]
               
               self.dbStore.collection("Appointments").document(appointId).setData(dict)
               
               
               self.getData()
          }
          
          let declineAction  = UIAlertAction(title: "Decline", style: .default) { (action) in
                        
                        print("DECLINE")
                        self.dbStore.collection("Requests").document((self.pendingList[button.tag].requestUid)!).updateData(["Status":"Declined"])
               self.getData()

                   }
              
          let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
          
          actionSheetView.addAction(acceptAction)
          actionSheetView.addAction(declineAction)
          actionSheetView.addAction(cancel)
          
          self.present(actionSheetView, animated: true, completion: nil)

              
         }
     
     
//     func randomString(length: Int) -> String {
//
//         let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//         let len = UInt32(letters.length)
//
//         var randomString = ""
//
//         for _ in 0 ..< length {
//             let rand = arc4random_uniform(len)
//             var nextChar = letters.character(at: Int(rand))
//             randomString += NSString(characters: &nextChar, length: 1) as String
//         }
//
//         return randomString
//     }
     
//     @objc func declineButtonAction (button : UIButton){
//
//          print("DECLINE")
//
//
//          dbStore.collection("Requests").document((pendingList[button.tag].requestUid)!).updateData(["Status":"Declined"])
//
//     }
     
     @objc func messageButtonAction (button : UIButton){
              print("Message")
          
          let sender = (sharedVariable.signInUser?.UserId)!
          let reciever = (pendingList[button.tag].SitterUid)!
          
          let vc = UIStoryboard(name: "Sitter", bundle: nil).instantiateViewController(identifier: "CHAT") as! SitterInboxVC
          
          vc.receiverID = reciever
          
          self.navigationController?.pushViewController(vc, animated: true)
         }


                                    //*************** OUTLET ACTION ******************

     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
          
     }
}




                                      //*************** EXTENSION ******************

extension SitterPendingVC: UITableViewDelegate, UITableViewDataSource{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return pendingList.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "PENDING", for: indexPath) as! PendingTableViewCell
          
          
          cell.personName.text = pendingList[indexPath.row].ParentName
          cell.personAddress.text = pendingList[indexPath.row].Address
          cell.ratingStar.value = CGFloat(pendingList[indexPath.row].Rate)
          cell.pendingHours.text = "\(String(describing: pendingList[indexPath.row].Hours!)) Hrs"
        



          if pendingList[indexPath.row].CreatedBy == (sharedVariable.signInUser?.UserId)!{
               
               if pendingList[indexPath.row].Status == "Accepted"{
                                  
                                  cell.pendingButton.setTitle("Accepted", for: .normal)
                                  cell.pendingButton.isUserInteractionEnabled = false

                                  cell.pendingButton.tag = indexPath.row
                                  cell.pendingButton.addTarget(self, action: #selector(pendingButtonAction), for: .touchUpInside)
                             }
                             else if pendingList[indexPath.row].Status == "Declined"{
                                  
                                  cell.pendingButton.setTitle("Declined", for: .normal)
                                  cell.pendingButton.isUserInteractionEnabled = false

                                  cell.pendingButton.tag = indexPath.row
                                  cell.pendingButton.addTarget(self, action: #selector(pendingButtonAction), for: .touchUpInside)
                             }
               
               else{
               cell.pendingButton.setTitle("PENDING", for: .normal)
               cell.pendingButton.isUserInteractionEnabled = false
               }
          }
          else{
               
               if pendingList[indexPath.row].Status == "Accepted"{
                    
                    cell.pendingButton.setTitle("Accepted", for: .normal)
                    cell.pendingButton.isUserInteractionEnabled = true

                    cell.pendingButton.tag = indexPath.row
                    cell.pendingButton.addTarget(self, action: #selector(pendingButtonAction), for: .touchUpInside)
               }
               else if pendingList[indexPath.row].Status == "Declined"{
                    
                    cell.pendingButton.setTitle("Declined", for: .normal)
                    cell.pendingButton.isUserInteractionEnabled = true

                    cell.pendingButton.tag = indexPath.row
                    cell.pendingButton.addTarget(self, action: #selector(pendingButtonAction), for: .touchUpInside)
               }
               
               else{
               cell.pendingButton.setTitle("REQUEST", for: .normal)
               cell.pendingButton.isUserInteractionEnabled = true

               cell.pendingButton.tag = indexPath.row
               cell.pendingButton.addTarget(self, action: #selector(pendingButtonAction), for: .touchUpInside)
               }
          }

        

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
