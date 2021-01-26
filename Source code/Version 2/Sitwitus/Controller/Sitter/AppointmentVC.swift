//
//  AppointmentVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 26/01/2021.
//  Copyright © 2021 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import SDWebImage

class AppointmentVC: UIViewController {
     
     
     //******** OUTLETS ***************

     @IBOutlet weak var appointmentTable : UITableView!

    //******** VARIABLES *************
     
     var dbStore = Firestore.firestore()
     
    var appointmentList = [Appointment]()
    //********* FUNCTIONS ***************


//******* VIEW FUNCTIONS

override func viewDidLoad() {
super.viewDidLoad()


}

override func viewWillAppear(_ animated: Bool) {
super.viewWillAppear(animated)
     
     appointmentTable.delegate = self
     appointmentTable.dataSource = self
     appointmentTable.reloadData()
     
     self.getData()
}
     
     
     func getData(){
          
          appointmentList.removeAll()
          appointmentTable.reloadData()
          
          let currentUser = sharedVariable.signInUser
          
          
          /*
           dbStore.collection("Appointments").whereField("SitterUid", isEqualTo: (currentUser?.UserId)!).order(by: "Timestamp").getDocuments
           */
          self.dbStore.collection("Appointments").whereField("SitterUid", isEqualTo: (currentUser?.UserId)!).getDocuments { (requestSnap, requestErr) in
               
               guard let fetchData = requestSnap?.documents else{return}
               
               
               let currentDate = Date()
               
               print(currentDate)
              
               
               fetchData.forEach { (VALUE) in
                    
                    let appointmentValue = try! FirestoreDecoder().decode(Appointment.self, from: VALUE.data())
                    
                    self.appointmentList.append(appointmentValue)
                    self.appointmentTable.reloadData()
               }
               
          }
          
          
          
     }

     @objc func checkPopWindow(){
          performSegue(withIdentifier: "Pop", sender: nil)

     }

     //*************** OUTLET ACTION ******************
     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
          
     }

}




       //*************** EXTENSION ******************


extension AppointmentVC: UITableViewDelegate,UITableViewDataSource{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return appointmentList.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "APPOINTMENT", for: indexPath) as! AppointmentTableViewCell
          
          
          let appointmentInfo = appointmentList[indexPath.row]
          cell.personName.text = appointmentInfo.ParentName
          
          let ImageString =  appointmentInfo.ParentImage ?? ""
          
     
          cell.personImage.sd_setImage(with: URL(string: ImageString), placeholderImage: UIImage(named: "pending"), options: .progressiveLoad, completed: nil)
          
          
          let start = appointmentInfo.Timestamp.seconds
          
          let startDate = Date(timeIntervalSince1970: TimeInterval(start))
          let dateFormatter = DateFormatter()
          dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
          dateFormatter.locale = NSLocale.current
          dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
          let startTime = dateFormatter.string(from: startDate)
          
          let duration = appointmentInfo.Hours!
          
          let convertInSecond = Int64(duration)! * 3600
          
          let finish = start + convertInSecond
          
          let finishDate = Date(timeIntervalSince1970: TimeInterval(finish))
          let finishTime = dateFormatter.string(from: finishDate)
          
     print(UUID())
          
          cell.dutyHours.text = "\(startTime) - \(finishTime)"
          
          cell.attendanceButton.tag = indexPath.row
          cell.attendanceButton.addTarget(self, action: #selector(checkPopWindow), for: .touchUpInside)
          
          return cell
     }
     
     
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 160
     }
     
}
