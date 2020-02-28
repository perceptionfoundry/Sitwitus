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

class ParentInboxVC: UIViewController {


                                    //******** OUTLETS ***************

     @IBOutlet weak var inboxTable : UITableView!

                                   //******** VARIABLES *************
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
         
     let dbStore = Firestore.firestore()
     let inboxList = [Message]()
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
    }

     func getData(){
          
          //******* CONVERSATION
          dbStore.collection("Conversation").document((sharedVariable.signInUser?.UserId)!).addSnapshotListener { (inboxSnap, inboxErr) in
               
               
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
          
          cell.userName.text = "shahrukh"
          cell.messsage.text = "dsnfkshdkjfnlskvbsd vsfkjsdjlkfhsdjfksdjfbsjkfjjkshflsjfl ksfjlsj f"
          cell.duration.text = "10min"
          cell.userImage.image = UIImage(named: "me")



          return cell
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 120
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          performSegue(withIdentifier: "Message_Segue", sender: nil)
     }
}
