//
//  SitterListViewVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 11/02/2021.
//  Copyright © 2021 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import CodableFirebase

class SitterListViewVC: UIViewController{

     //MARK: OUTLETS

     @IBOutlet weak var parentList : UITableView!

     //MARK:  VARIABLES

     var parents  = [Users]()
     
     var selectedIndex = -1
     
     
     
     //************  FUNCTIONS


     //MARK:  VIEW FUNCTIONS

override func viewDidLoad() {
super.viewDidLoad()


}

override func viewWillAppear(_ animated: Bool) {
super.viewWillAppear(animated)
     
     parentList.delegate = self
     parentList.dataSource = self
     self.fetchSitter()
}

     
     
     
     //MARK: FETCH SITTER LIST
     
     func fetchSitter(){
          
          parents.removeAll()
          parentList.reloadData()
          
          let dbStore = Firestore.firestore()
          
          dbStore.collection("Users").getDocuments { (sitterSnap, sitterErr) in
               
               guard  let fetchData = sitterSnap?.documents else{return}
               
               
               fetchData.forEach { (value) in
                    
                    let dict = value.data()
                    
                    let sitterInfo = try! FirebaseDecoder().decode(Users.self, from: dict)
                    
                    
                    
                    if sitterInfo.UserType == "Parent"{
                    self.parents.append(sitterInfo)
                    self.parentList.reloadData()
 
                         
                    }
               }
          }
          
     }

     
     //MARK: Request Action
     @objc func BookingAction(button: UIButton){
             
             print(button.tag)
             
             self.selectedIndex = button.tag
             performSegue(withIdentifier: "Booking_Segue", sender: nil)
        }
        
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             
             
             if segue.identifier == "Booking_Segue"{
             let dest = segue.destination  as! SitterBookingVC
             
          
             dest.parents = parents[self.selectedIndex]
             }
        }

     //MARK:  OUTLET ACTION

     @IBAction func backButtonAction(){
          self.navigationController?.popViewController(animated: true)
     }

}




     //MARK:  EXTENSION

extension SitterListViewVC: UITableViewDelegate, UITableViewDataSource{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return parents.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "Sitter", for: indexPath) as! SitterListTableViewCell
          
          cell.sitterName.text = parents[indexPath.row].FullName
          
          let imageURL = URL(string: parents[indexPath.row].ImageUrl)
          
          cell.sitterImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "new_image"), options: .progressiveLoad, completed: nil)
          
          cell.requestButton.addTarget(self, action: #selector(BookingAction), for: .touchUpInside)
          
          return cell
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 120
     }
     
}
