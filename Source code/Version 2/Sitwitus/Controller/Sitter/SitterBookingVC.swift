//
//  SitterBookingVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 02/03/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import HCSStarRatingView
import SDWebImage
import Firebase

class SitterBookingVC: UIViewController{


                                    //******** OUTLETS ***************

     @IBOutlet weak var parentName: UILabel!
     @IBOutlet weak var parentImage: Custom_ImageView!
     @IBOutlet weak var childrenQuantity: UILabel!
     @IBOutlet weak var duration: UILabel!
     @IBOutlet weak var duty: UILabel!
     @IBOutlet weak var need: UILabel!
     @IBOutlet weak var rateStars: HCSStarRatingView!
      @IBOutlet weak var offerRate: UITextField!
     @IBOutlet weak var hours: UITextField!
     
     
      
     
     
     

                                   //******** VARIABLES *************
     var parents : Users!
     var dbStore = Firestore.firestore()
     var tipPercent = 10
     
     
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
     
     parentName.text = parents.FullName
     parentImage.sd_setImage(with: URL(string: parents.ImageUrl), placeholderImage: UIImage(named: "profile_Image"), options: .progressiveLoad, completed: nil)
     
     senderID = (sharedVariable.signInUser?.UserId)!
     recieverID = parents.UserId
     
     
     
     
     //******* Requirement
     dbStore.collection("Users").document(parents.UserId).collection("Requirement").document("Value").getDocument { (snapResult, snapErr) in
          
          guard let fetchdata = snapResult?.data()  else{return}
          
         
          print(fetchdata)
          
          self.childrenQuantity.text = (fetchdata["Children"] as! String)
          self.duration.text = (fetchdata["Duration"] as! String)
          self.duty.text = (fetchdata["Duty"] as! String)
          self.need.text = (fetchdata["Need"] as! String)



//
//          self.childrenQuantity.text =  skill.joined(separator: ",")
          self.childrenQuantity.textColor = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
          self.duration.textColor = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
          self.duty.textColor = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
          self.need.textColor = (UIColor(red: 0.369, green: 0.737, blue: 0.753, alpha: 1))
     }
     
     
   
     
     
     rateStars.value = CGFloat(parents.Star ?? 1.0)
     
//     tipAmount.text = "$ \(sitter.Rate!)"
     
    }



                                    //*************** OUTLET ACTION ******************

     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
     }
     
     
     //MARK: Booking
     
     @IBAction func bookingButton(){
          
          
          
          let colletionRef = dbStore.collection("Requests").document()


          if hours.text?.isEmpty == false && offerRate.text?.isEmpty == false{
               
          let dict = [
               "Timestamp": FieldValue.serverTimestamp(),
               "CreatedBy": (sharedVariable.signInUser?.UserId)!,
               "Address": (sharedVariable.signInUser?.Location)!,
               "Lat":(sharedVariable.signInUser?.Lat)!,
               "Long": (sharedVariable.signInUser?.Long)!,
               "SitterName": (sharedVariable.signInUser?.FullName)!,
               "SitterUid":(sharedVariable.signInUser?.UserId)!,
               "SitterImage":(sharedVariable.signInUser?.ImageUrl)!,
               "ParentName":(parents.FullName)!,
               "ParentUid":(parents.UserId)!,
               "SitterReview": (sharedVariable.signInUser?.Star) ?? 1,
               "ParentImage":(parents.ImageUrl)!,
               "Rate":Double((offerRate.text)!)!,
               "Tip": 0.0,
               "Hours": (self.hours.text)!,
               "Date": "",
               "Time": "",
               "Status": "Requested",
               "requestUid": colletionRef.documentID
               ] as [String:Any]

               colletionRef.setData(dict)
   

               //******* CHATROOM *****
                        
                        
                        var chatRoom = ""
                        
                        let senderID = (sharedVariable.signInUser?.UserId)!
                        let recieverID = (parents.UserId)!
                        
                        if senderID < recieverID{
                             
                             chatRoom = senderID + recieverID
                        }else{
                             chatRoom = recieverID + senderID
                        }
                        
                        print("chatroom: \(chatRoom)")
                        
                        
                        let collectionRef = dbStore.collection("ChatRoom").document(chatRoom).collection("Messages").document()
                                 
                                 // ****** CREATE MESSAGE INFO *****
                                 
                                 let basisDict = ["addedOn": FieldValue.serverTimestamp(),
                                                  "chatId": collectionRef.documentID,
                                                  "roomId": chatRoom,
                                                  "senderId" : (sharedVariable.signInUser?.UserId)!,
                                                  "receiverId" : recieverID,
                                                  "senderName": (sharedVariable.signInUser?.FullName)!,
                                                  "recieverName" : (parents.FullName)!,
                                                  "senderImageURL" : (sharedVariable.signInUser?.ImageUrl)!,
                                                  "recieverImageURL" : (parents.ImageUrl)!,
                                                  "readerID":recieverID,
                                                  "context"  : "",
                                                  "composerId" : (sharedVariable.signInUser?.UserId)!,
                                                  "type": "TEXT",
                                                  "isDeleted": false,
                                                  "isRead" : false] as [String : Any]
                                 
                                 collectionRef.setData(basisDict)
                        
                        
                        dbStore.collection("Conversation").document(chatRoom).setData(["chatRoom":chatRoom])
                        
                        
                        //************ CONVERSATION **********
                                
                                if senderConversationId.contains(chatRoom) == false {
                                     self.senderConversationId.append(chatRoom)
                                     dbStore.collection("Conversation").document(self.senderID).setData(["chatRoom":self.senderConversationId])
                                }
                                if receiverConversationId.contains(chatRoom) == false{
                                     self.receiverConversationId.append(chatRoom)
                                     dbStore.collection("Conversation").document(self.recieverID).setData(["chatRoom":self.receiverConversationId])
                                }
                        
//                        let story = UIStoryboard(name: "Parent", bundle: nil)
//                        let vc = story.instantiateViewController(withIdentifier: "MAIN")
//
//                        self.navigationController?.pushViewController(vc, animated: true)
               
               self.navigationController?.popViewController(animated: true)
          
         
          }else{
               let alert = AlertWindow()
               
               alert.simple_Window(Title: "TEXTFIELD EMPTY", Message: "Please fill respective field", View: self)
          }
     }
     
   
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
          let dest = segue.destination  as! ParentBookingReviewVC
          
          dest.bookingDict = sender as! [String:Any]
     }


}




                                      //*************** EXTENSION ******************
