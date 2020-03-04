//
//  ParentInboxVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 10/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import SDWebImage

class ParentInboxVC: UIViewController {


                                    //******** OUTLETS ***************

     @IBOutlet weak var inboxTable : UITableView!

                                   //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
         
     let dbStore = Firestore.firestore()
     var inboxList = [[String:Any]]()
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     inboxTable.delegate = self
     inboxTable.dataSource = self
     inboxTable.reloadData()
     
     self.getData()
    }

     func getData(){
          
          inboxList.removeAll()
          inboxTable.reloadData()
          
          //******* CONVERSATION
          dbStore.collection("Conversation").document((sharedVariable.signInUser?.UserId)!).addSnapshotListener { (inboxSnap, inboxErr) in
               
               guard let fetchData = inboxSnap?.data() else{return}
               
               print(fetchData["chatRoom"] as! [String])
               
               
               
               let conversationList = fetchData["chatRoom"] as! [String]
               
               conversationList.forEach { (chatID) in
                    
                    let count = 0
                    
                    if count <= conversationList.count{
                         
                         self.dbStore.collection("ChatRoom").document(chatID).collection("Messages").getDocuments { (msgSnap, msgErr) in
                              
                              guard let fetchMsgs = msgSnap?.documents else{return}
                              
                              
                              let lastValue  = fetchMsgs.last?.data() as! [String:Any]
                              
                              let msgCodable = try! FirestoreDecoder().decode(Message.self, from: lastValue)
                              
                              print(lastValue)
                              
                              let listData = ["ChatRoom": chatID, "Data": msgCodable] as [String : Any]
                              
                              self.inboxList.append(listData)
                              
                              
                              print(self.inboxList)
                              
                              self.inboxTable.reloadData()
                              
//                              fetchMsgs.forEach { (msg) in
//
//                                   print(msg.data())
//
//                                   let value = msg.data()
//                              }

                         }
                    }
                    
               }
               
               
               
               
               
          }
          
     }


                                    //*************** OUTLET ACTION ******************

     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
     }
}




                                      //*************** EXTENSION ******************

extension ParentInboxVC: UITableViewDelegate, UITableViewDataSource{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return inboxList.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "INBOX", for: indexPath) as! InboxTableViewCell
          
          
          let displayValue = self.inboxList[indexPath.row]
          let dataValue = displayValue["Data"] as! Message
          cell.userName.text = dataValue.recieverName
          cell.messsage.text = dataValue.context
          cell.duration.text = "10min"
          
          let image = dataValue.recieverImageURL
          
          cell.userImage.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "profile_Image"), options: .progressiveLoad, completed: nil)


          return cell
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 120
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          
           let indexNumber = indexPath.row
          
          performSegue(withIdentifier: "Message_Segue", sender: indexNumber)
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
          if segue.identifier == "Message_Segue"{
          
               let dest = segue.destination as! ParentMessageVC
               
              let value = self.inboxList[sender as! Int]
               let dataValue = value["Data"] as! Message
               
               dest.senderId = dataValue.senderId
               dest.recieverId = dataValue.receiverId
               dest.chatRoomTitle = dataValue.roomId
               
              
          }
     }
}
