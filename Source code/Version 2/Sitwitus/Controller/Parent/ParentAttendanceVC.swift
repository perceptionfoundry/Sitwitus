//
//  ParentAttendanceVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 10/02/2021.
//  Copyright © 2021 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import SDWebImage


class ParentAttendanceVC: UIViewController {
     
     
     
     
     //******** OUTLETS ***************

     @IBOutlet weak var attendanceTable : UITableView!

    //******** VARIABLES *************
     
     var dbStore = Firestore.firestore()
     
    var attendanceList = [Appointment]()
     
     var appoint_Attendance : Appointment?
    //********* FUNCTIONS ***************


//******* VIEW FUNCTIONS

override func viewDidLoad() {
super.viewDidLoad()


}

override func viewWillAppear(_ animated: Bool) {
super.viewWillAppear(animated)
     
     attendanceTable.delegate = self
     attendanceTable.dataSource = self
     attendanceTable.reloadData()
     
     self.getData()
}
     
     
     func getData(){
          
          attendanceList.removeAll()
          attendanceTable.reloadData()
          
          let currentUser = sharedVariable.signInUser
          
          
          /*
           dbStore.collection("Appointments").whereField("SitterUid", isEqualTo: (currentUser?.UserId)!).order(by: "Timestamp").getDocuments
           */
          self.dbStore.collection("Attendance").whereField("ParentUid", isEqualTo: (currentUser?.UserId)!).getDocuments { (requestSnap, requestErr) in
               
               guard let fetchData = requestSnap?.documents else{return}
      
               fetchData.forEach { (VALUE) in
                    
                    let appointmentValue = try! FirestoreDecoder().decode(Appointment.self, from: VALUE.data())
                    
                    self.attendanceList.append(appointmentValue)
                    self.attendanceTable.reloadData()
               }
               
          }
          
          
          
     }

     @objc func taskComplete(_ sender : UIButton){

          self.appoint_Attendance = attendanceList[sender.tag]

         
         let dict = [ "requestedTo":(appoint_Attendance?.SitterUid)!,
           "isVerified": true] as [String : Any]
          
        
          dbStore.collection("Attendance").document((appoint_Attendance?.appointmentId)!).updateData(dict)
          attendanceTable.reloadData()
          
          dbStore.collection("Appointments").document((appoint_Attendance?.appointmentId)!).updateData(dict)
         
          getData()
          
          let vc = UIStoryboard(name: "Parent", bundle: nil).instantiateViewController(identifier: "CheckOut") as ParentCheckOutVC
          
          vc.sitterUid = (appoint_Attendance?.SitterUid)!
          
          self.present(vc, animated: true, completion: nil)

     }
     
    


     //*************** OUTLET ACTION ******************
     @IBAction func backButton(){
          self.navigationController?.popViewController(animated: true)
          
     }

}


//*************** EXTENSION ******************


extension ParentAttendanceVC: UITableViewDelegate,UITableViewDataSource{

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   return attendanceList.count
     
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
   let cell = tableView.dequeueReusableCell(withIdentifier: "ATTENDANCE", for: indexPath) as! AttendanceTableView
   
   
   let attendancetInfo = attendanceList[indexPath.row]
   cell.personName.text = attendancetInfo.SitterName
   
   
   cell.personAddress.text = attendancetInfo.Address
   cell.bookingNumber.text = attendancetInfo.appointmentId
   
   let ImageString =  attendancetInfo.ParentImage ?? ""
   cell.personImage.sd_setImage(with: URL(string: ImageString), placeholderImage: UIImage(named: "pending"), options: .progressiveLoad, completed: nil)

   
   // ************ Start Time
   let combine = attendancetInfo.Date + " " +  attendancetInfo.Time
   let intoDate = combine.toDate()
   let start = intoDate?.timeIntervalSince1970
   
     print("****************")
     print(combine)
     print(intoDate)
     print("****************")

     
   let startDate = Date(timeIntervalSince1970: TimeInterval(start!))
   let dateFormatter = DateFormatter()
   dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
   dateFormatter.locale = NSLocale.current
   dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
   let startTime = dateFormatter.string(from: startDate)

   let duration = attendancetInfo.Hours!


   //********** Calculating end time
   let convertInSecond = Double(duration)! * 3600

   let finish = start! + convertInSecond
//
   let finishDate = Date(timeIntervalSince1970: TimeInterval(finish))
   let finishTime = dateFormatter.string(from: finishDate)

   cell.dutyHours.text = "\(startTime) - \(finishTime)"
   
   
   if attendancetInfo.Status == "CheckIn" {
        
        cell.attendanceButton.setTitle("Check-In Confirm", for: .normal)
        cell.attendanceButton.backgroundColor = .clear
        cell.attendanceButton.setTitleColor(.systemGreen, for: .normal)
        cell.attendanceButton.layer.borderColor = UIColor.systemGreen.cgColor
        cell.attendanceButton.layer.borderWidth = 2.0
        
   }else if attendancetInfo.Status == "CheckOut" {
        cell.attendanceButton.setTitle("Check-Out", for: .normal)
        cell.attendanceButton.backgroundColor = .clear
        cell.attendanceButton.setTitleColor(.systemRed, for: .normal)
        cell.attendanceButton.layer.borderColor = UIColor.systemRed.cgColor
        cell.attendanceButton.layer.borderWidth = 2.0
   }
    if attendancetInfo.isVerified == true {
        cell.attendanceButton.setTitle("Completed", for: .normal)
     cell.attendanceButton.backgroundColor = .clear
        cell.attendanceButton.setTitleColor(.systemGreen, for: .normal)
        cell.attendanceButton.layer.borderColor = UIColor.systemGreen.cgColor
        cell.attendanceButton.layer.borderWidth = 2.0
   }
//
   cell.attendanceButton.tag = indexPath.row
   
   if attendancetInfo.Status == "CheckOut"{
   cell.attendanceButton.addTarget(self, action: #selector(taskComplete), for: .touchUpInside)
    
   }
   return cell
}



func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   return 160
}

}




