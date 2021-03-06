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
     
     var senderID = (sharedVariable.signInUser?.UserId)!
     var receiverID = ""
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
               
               
               
               
               let conversationList = fetchData["chatRoom"] as! [String]
               
               conversationList.forEach { (chatID) in
                    
                    let count = 0
                    
                    if count <= conversationList.count{
                         
                         self.dbStore.collection("ChatRoom").document(chatID).collection("Messages").getDocuments { (msgSnap, msgErr) in
                              
                              guard let fetchMsgs = msgSnap?.documents else{return}
                              
                              
                              let lastValue  = fetchMsgs.last?.data()
                              
                              let msgCodable = try! FirestoreDecoder().decode(Message.self, from: lastValue!)
                              
                              
                              let listData = ["ChatRoom": chatID, "Data": msgCodable] as [String : Any]
                              
                              self.inboxList.append(listData)
                              
                              self.inboxTable.reloadData()
                              
//

                         }
                    }
                    
               }
  
          }
          
     }

     
     //******** GET TIME DIFFERENCE
     func getTimeDifferenceString(olderDate older: Date) -> (String?)  {
          
          let currentDate = Date()
          
         let formatter = DateComponentsFormatter()
         formatter.unitsStyle = .short
         
         let componentsLeftTime = Calendar.current.dateComponents([.minute , .hour , .day,.month, .weekOfMonth,.year], from: older, to: currentDate)
         
         let year = componentsLeftTime.year ?? 0
         if  year > 0 {
             formatter.allowedUnits = [.year]
             return formatter.string(from: older, to: currentDate)
         }
         
         
         let month = componentsLeftTime.month ?? 0
         if  month > 0 {
             formatter.allowedUnits = [.month]
             return formatter.string(from: older, to: currentDate)
         }
         
         let weekOfMonth = componentsLeftTime.weekOfMonth ?? 0
         if  weekOfMonth > 0 {
             formatter.allowedUnits = [.weekOfMonth]
             return formatter.string(from: older, to: currentDate)
         }
         
         let day = componentsLeftTime.day ?? 0
         if  day > 0 {
             formatter.allowedUnits = [.day]
             return formatter.string(from: older, to: currentDate)
         }
         
         let hour = componentsLeftTime.hour ?? 0
         if  hour > 0 {
             formatter.allowedUnits = [.hour]
             return formatter.string(from: older, to: currentDate)
         }
         
         let minute = componentsLeftTime.minute ?? 0
         if  minute > 0 {
             formatter.allowedUnits = [.minute]
             return formatter.string(from: older, to: currentDate) ?? ""
         }
         
         
         return nil
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
          
          let msgTime = (dataValue.addedOn.dateValue())
          
          let diff = getTimeDifferenceString(olderDate: msgTime)
          
          print(diff)
          
          cell.duration.text = diff ?? "now"
          
          
          if (sharedVariable.signInUser?.FullName)! == dataValue.senderName{
               cell.userName.text = dataValue.recieverName
               let image = dataValue.recieverImageURL
                        
               cell.userImage.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "profile_Image"), options: .progressiveLoad, completed: nil)
               
        
          }
          else{
               cell.userName.text = dataValue.senderName
               let image = dataValue.senderImageURL
                        
               cell.userImage.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "profile_Image"), options: .progressiveLoad, completed: nil)
          }
         cell.messsage.text = dataValue.context

          
         


          return cell
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 120
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          
          let indexNumber = indexPath.row
          
          
          
          let displayValue = self.inboxList[indexPath.row]
               let dataValue = displayValue["Data"] as! Message
               
          
               
               
               if (sharedVariable.signInUser?.UserId)! == dataValue.senderId{
                
                    self.receiverID = dataValue.receiverId
               }
               else{
                  
                    self.receiverID = dataValue.senderId

               }
          
          

          
          performSegue(withIdentifier: "Message_Segue", sender: indexNumber)
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
          if segue.identifier == "Message_Segue"{
          
               let dest = segue.destination as! ParentMessageVC
               
              let value = self.inboxList[sender as! Int]
               let dataValue = value["Data"] as! Message
               
               
       
               
               dest.senderId = self.senderID
               dest.recieverId = self.receiverID
               dest.chatRoomTitle = dataValue.roomId
               
              
          }
     }
}
