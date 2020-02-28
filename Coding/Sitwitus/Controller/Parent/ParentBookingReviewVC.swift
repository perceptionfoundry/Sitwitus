//
//  ParentBookingReviewVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 13/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase


class ParentBookingReviewVC: UIViewController {


                                    //******** OUTLETS ***************


     @IBOutlet weak var container_View: UIView!
     
     
                                   //******** VARIABLES *************
     let dbStore = Firestore.firestore()
     var bookingDict = [String:Any]()
     
     var senderID = ""
     var recieverID = ""
     
     var senderConversationId = [String]()
     var receiverConversationId = [String]()
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     senderID = (sharedVariable.signInUser?.UserId)!
     recieverID = self.bookingDict["SitterUid"] as! String
    }
     
     
     
     //******** GETTING PAST CONVERSATION LIST
     
     func pastConversation(){
          
          dbStore.collection("Conversation").document(self.senderID).addSnapshotListener { (conversationSnap, conversationErr) in
               
               guard let  value = conversationSnap?.data() else{return}
               
               self.senderConversationId = value["chatRoom"]  as! [String]
               
               
               print("*****************")
               print(self.senderConversationId)
               print("**************")
          }
          
          
          dbStore.collection("Conversation").document(self.recieverID).addSnapshotListener { (conversationSnap, conversationErr) in
               
               guard let  value = conversationSnap?.data() else{return}
               
               self.receiverConversationId = value["chatRoom"]  as! [String]
               
               
               print("*****************")
               print(self.receiverConversationId)
               print("**************")
          }
          
     }




                                    //*************** OUTLET ACTION ******************

     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
     }
     
     @IBAction func confirmButton(){
          
          
          
//
//          let colletionRef = dbStore.collection("Requests").document()
//
//          self.bookingDict["Timestamp"] = FieldValue.serverTimestamp()
//          self.bookingDict["requestUid"] = colletionRef.documentID
//
//          colletionRef.setData(self.bookingDict)
          
          
          //******* CHATROOM *****
          
          
          var chatRoom = ""
          
          let senderID = (sharedVariable.signInUser?.UserId)!
          let recieverID = self.bookingDict["SitterUid"] as! String
          
          if senderID < recieverID{
               
               chatRoom = senderID + recieverID
          }else{
               chatRoom = recieverID + senderID
          }
          
          print("chatroom: \(chatRoom)")
          
          
          let collectionRef = dbStore.collection("ChatRoom").document()
                   
                   // ****** CREATE MESSAGE INFO *****
                   
                   let basisDict = ["addedOn": FieldValue.serverTimestamp(),
                                    "chatId": collectionRef.documentID,
                                    "roomId": chatRoom,
                                    "senderId" : senderID,
                                    "receiverId" : recieverID,
                                    "senderName": (sharedVariable.signInUser?.FullName)!,
                                    "recieverName" : self.bookingDict["SitterName"] as! String,
                                    "senderImageURL" : (sharedVariable.signInUser?.ImageUrl)!,
                                    "recieverImageURL" : self.bookingDict["SitterImage"] as! String,
                                    "readerID":recieverID,
                                    "context"  : "Hi there!!",
                                    "composerId" : senderID,
                                    "type": "TEXT",
                                    "isDeleted": false,
                                    "isRead" : false] as [String : Any]
                   
                   collectionRef.setData(basisDict)
          
          
          dbStore.collection("Conversation").document(senderID).setData(["chatRoom":chatRoom])
          
          
          //************ CONVERSATION **********
                  
                  if senderConversationId.contains(chatRoom) == false {
                       self.senderConversationId.append(chatRoom)
                       dbStore.collection("Conversation").document(self.senderID).setData(["chatRoom":self.senderConversationId])
                  }
                  if receiverConversationId.contains(chatRoom) == false{
                       self.receiverConversationId.append(chatRoom)
                       dbStore.collection("Conversation").document(self.recieverID).setData(["chatRoom":self.receiverConversationId])
                  }
          
          let story = UIStoryboard(name: "Parent", bundle: nil)
          let vc = story.instantiateViewController(withIdentifier: "MAIN")
          
          self.navigationController?.pushViewController(vc, animated: true)
     }

}




                                      //*************** EXTENSION ******************
