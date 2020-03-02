//
//  ParentMessageVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 10/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class ParentMessageVC: UIViewController
{
     
     
                                             //******** OUTLETS ***************
     
     @IBOutlet weak var messageTable: UITableView!
     @IBOutlet weak var messageTF: UITextView!
     @IBOutlet weak var textViewHeight: NSLayoutConstraint!
     
                                             
                                                  //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
     }
     
     let dbRef = Firestore.firestore()
     
     var maxheight:CGFloat = 80
     var bubbleHeight = [CGFloat]()
     
     var chatRoomTitle = ""
     var senderDetail = sharedVariable.signInUser!
     var recieverDetail : Users?
     
     var recieverId = ""
     var reciverImage : UIImage?
     var senderId = ""
     
          
     var allMessage = [Message]()
     var sendMessage = ""
     
     var senderConversationId = [String]()
     var receiverConversationId = [String]()
     
                                             //********* FUNCTIONS ***************
     
     
     //******* VIEW FUNCTIONS
     
     override func viewDidLoad() {
          super.viewDidLoad()
          
          
     }
     
     override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          
          print("SENDER: \(senderId)")
          print("RECEIVER: \(recieverId)")
          
          
          messageTF.delegate = self
          
          messageTF.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneAction))
          
          let sender_Nib = UINib(nibName: "SenderTableViewCell", bundle: nil)
          messageTable.register(sender_Nib, forCellReuseIdentifier: "SENDER")
          
          let receiver_Nib = UINib(nibName: "RecieverTableViewCell", bundle: nil)
          messageTable.register(receiver_Nib, forCellReuseIdentifier: "RECEIVER")
          
          let time_Nib = UINib(nibName: "TImeTableViewCell", bundle: nil)
          messageTable.register(time_Nib, forCellReuseIdentifier: "TIME")
          
          
     }
     
     
     //****** MARK READ
     func makeRead(chatID : String){
          
          let dict = ["isRead": true]
          dbRef.collection("ChatRoom").document(chatID).updateData(dict)
          
     }
     
     
     //******** GETTING PAST CONVERSATION LIST
     
     func pastConversation(){
          
          dbRef.collection("Conversation").document(self.senderId).addSnapshotListener { (conversationSnap, conversationErr) in
               
               guard let  value = conversationSnap?.data() else{return}
               
               self.senderConversationId = value["chatRoom"]  as! [String]
               
               
               print("*****************")
               print(self.senderConversationId)
               print("**************")
          }
          
          
          dbRef.collection("Conversation").document(self.recieverId).addSnapshotListener { (conversationSnap, conversationErr) in
               
               guard let  value = conversationSnap?.data() else{return}
               
               self.receiverConversationId = value["chatRoom"]  as! [String]
               
               
               print("*****************")
               print(self.receiverConversationId)
               print("**************")
          }
          
     }
     
     
     //****** RETREIVE MESSAGE
     
     func fetchMessage(){
          
          
          
          
          self.dbRef.collection("ChatRoom").whereField("roomId", isEqualTo: self.chatRoomTitle).order(by: "addedOn", descending: false).addSnapshotListener { (chatSnap, chatError) in
               
               guard let fetchValue = chatSnap?.documents else{return}
               
               self.allMessage.removeAll()
               
               fetchValue.forEach { (value) in
                    
                    let getData = value.data()
                    
                    
                    
                    let msg = try! FirestoreDecoder().decode(Message.self, from: getData)
                    
                    if msg.readerID == self.senderId{
                         self.makeRead(chatID: msg.chatId)
                    }
                    
                    self.allMessage.append(msg)
                    self.messageTable.delegate = self
                    self.messageTable.dataSource = self
                    self.messageTable.reloadData()
                    
                    let indexPath = NSIndexPath(item: self.allMessage.count - 1, section: 0)
                    self.messageTable.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                    
                    
                    
               }
          }
     }
     
     
     //******* SEND MESSAGE
     
     func sendText(){
          
          
          
          let collectionRef = self.dbRef.collection("ChatRoom").document()
          
          // ****** CREATE MESSAGE INFO *****
          
          let basisDict = ["addedOn": FieldValue.serverTimestamp(),
                           "chatId": collectionRef.documentID,
                           "roomId": self.chatRoomTitle,
                           "senderId" : self.senderId,
                           "receiverId" : self.recieverId,
                           "senderName": (self.senderDetail.FullName)!,
                           "recieverName" : (self.recieverDetail?.FullName)!,
                           "senderImageURL" : (self.senderDetail.ImageUrl)!,
                           "recieverImageURL" : (self.recieverDetail?.ImageUrl)!,
                           "readerID":self.recieverId,
                           "context"  : self.sendMessage,
                           "composerId" : self.senderId,
                           "type": "TEXT",
                           "isDeleted": false,
                           "isRead" : false] as [String : Any]
          
          collectionRef.setData(basisDict)
          
          //************ CONVERSATION **********
          
          if senderConversationId.contains(chatRoomTitle) == false {
               self.senderConversationId.append(self.chatRoomTitle)
               dbRef.collection("Conversation").document(self.senderId).setData(["chatRoom":self.senderConversationId])
          }
          if receiverConversationId.contains(chatRoomTitle) == false{
               self.receiverConversationId.append(self.chatRoomTitle)
               dbRef.collection("Conversation").document(self.recieverId).setData(["chatRoom":self.receiverConversationId])
          }
          
          
          
          
          self.allMessage.removeAll()
          self.messageTable.reloadData()
     }
     
     
     
     @objc func doneAction(){
          
          self.returnAction()
     }
     
     
     
     
     func returnAction(){
          
          
          
          //
          self.sendMessage = self.messageTF.text!
          self.messageTF.text = "Say Something..."
          self.messageTF.textColor = UIColor(red: 0.073, green: 0.624, blue: 0.616, alpha: 1)
          
          self.messageTable.reloadData()
          
          //************
          self.sendText()
          
     }
     
     
                                   //*************** OUTLET ACTION ******************
     
     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
     }
     
     @IBAction func sendButton(){
          self.returnAction()
     }
}




                                   //*************** EXTENSION ******************

extension ParentMessageVC: UITableViewDataSource, UITableViewDelegate{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 5
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          if indexPath.row == 0{
               let cell = tableView.dequeueReusableCell(withIdentifier: "TIME", for: indexPath)
               
               return cell
          }
               
          else if self.senderId == self.allMessage[indexPath.row].composerId!{
               
               let cell = tableView.dequeueReusableCell(withIdentifier: "SENDER", for: indexPath) as! SenderTableViewCell
               
               cell.messsage.text = (self.allMessage[indexPath.row].context!)
               
               return cell
               
               
               
          }
               
               
          else{
               let cell = tableView.dequeueReusableCell(withIdentifier: "RECEIVER", for: indexPath)
               
               return cell
               
          }
          
     }
     
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableView.automaticDimension
     }
}



                         //********************************* TEXTFIELD DELEGATE *********************************

extension ParentMessageVC: UITextViewDelegate{
     
     
     
     
     func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
          
          if textView.text == "Say Something..." {
               textView.text = ""
               messageTF.textColor = UIColor.black
               
          }
          
          return true
     }
     
     
     
     
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
          
          
          if messageTF.contentSize.height < maxheight && messageTF.contentSize.height > 44{
               textViewHeight.constant = messageTF.contentSize.height
          }
          
          if (text == "\n") {
               
               
               
               //            self.returnAction()
               textView.resignFirstResponder()
               
               
          }
          
          return true
          
     }
     
     func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
          
          if textView.text == "" {
               textView.text = "Say Something..."
               messageTF.textColor = UIColor(red: 0.073, green: 0.624, blue: 0.616, alpha: 1)
               
          }
          
          
          return true
     }
     
}
