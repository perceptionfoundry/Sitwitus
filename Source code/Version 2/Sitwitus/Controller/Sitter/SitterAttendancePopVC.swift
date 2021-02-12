//
//  SitterAttendancePopVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 25/01/2021.
//  Copyright © 2021 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation


var selectedAppointment : Appointment!

class SitterAttendancePopVC: UIViewController {
     
     
     //******** OUTLETS ***************

     @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
     @IBOutlet weak var popView: Custom_View!
     @IBOutlet weak var checkTitle: UILabel!
     @IBOutlet weak var elapseTime: UILabel!
     @IBOutlet weak var checkButton: Custom_Button!
     

    //******** VARIABLES *************

     let dbStore = Firestore.firestore()
     var locationManager = CLLocationManager()
     var currentLocation : CLLocation!
     var statusProtocol : statusUpdate!
    //********* FUNCTIONS ***************


//******* VIEW FUNCTIONS

override func viewDidLoad() {
super.viewDidLoad()

     locationManager.delegate = self
     locationManager.requestAlwaysAuthorization()
     locationManager.desiredAccuracy = kCLLocationAccuracyBest
     
     locationManager.startUpdatingLocation()
     

}

override func viewWillAppear(_ animated: Bool) {
super.viewWillAppear(animated)
     
     if selectedAppointment.Status == "CheckIn"{
          
          checkButton.setTitle("Check-Out", for: .normal)
          checkButton.backgroundColor = .systemRed
         
     }
     
     self.bottomConstraint.constant = -150
     
     let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
     
     view.addGestureRecognizer(tap)
  
     UIView.animate(withDuration: 3, delay: 500, options: .curveEaseIn) {
                    self.bottomConstraint.constant += 150
               }
     
     

     let formattor = DateFormatter()
     
     
 
     formattor.dateFormat = "hh:mm a"
     let time = formattor.string(from: Date())
     print(time)
     elapseTime.text = time
     
     
 
     
}

     @objc func dismissAction(){
          
          
          UIView.animate(withDuration: 3, delay: 500, options: .curveEaseOut) {
                    self.bottomConstraint.constant -= 150
               } completion: { (status) in
                    
                    if status{
                         self.dismiss(animated: true, completion: nil)
                    }
               }
          
     }

     //*************** OUTLET ACTION ******************

     @IBAction func CheckButtonAction(_ sender: Any) {
          
          
          dbStore.collection("Appointments").document(selectedAppointment.appointmentId).updateData(["Status": "CheckIn"])
          
          
          
          let currentUser = sharedVariable.signInUser
          
          
          if selectedAppointment.Status == "Accepted"{
          let dict = ["appointmentId": (selectedAppointment.appointmentId)!,
                      "CreatedBy": (currentUser?.UserId)!,
                      "Address": selectedAppointment.Address,
                      "BookingNumber": selectedAppointment.appointmentId!,
                      "Hours": selectedAppointment.Hours!,
                      "Date": selectedAppointment.Date!,
                      "Time": selectedAppointment.Time!,
                      "Lat": self.currentLocation.coordinate.latitude,
                      "Long": self.currentLocation.coordinate.longitude,
                      "ParentName": selectedAppointment.ParentName!,
                      "ParentUid": selectedAppointment.ParentUid!,
                      "SitterName": (currentUser?.FullName)!,
                      "SitterUid": (currentUser?.UserId)!,
                      "SignInTime": FieldValue.serverTimestamp(),
                      "SignOutTime": FieldValue.serverTimestamp(),
                      "Status": "CheckIn",
                      "Timestamp": FieldValue.serverTimestamp(),
                      "requestedTo":(selectedAppointment.ParentUid)!,
                      "isVerified": false,
                      
                      ] as [String : Any]
          
          
          dbStore.collection("Attendance").document(selectedAppointment.appointmentId).setData(dict)
               
               UIView.animate(withDuration: 3, delay: 0.5, options: .curveEaseOut) {
                         self.bottomConstraint.constant -= 150
               } completion: { [self] (status) in
                         
                         if status{
                              statusProtocol.triggerStatus(status: "CheckIn")
                              self.dismiss(animated: true, completion: nil)
                         }
                    }
          }else if selectedAppointment.Status == "CheckIn"{
               
               
               let dict = [
                           "SignOutTime": FieldValue.serverTimestamp(),
                           "Status": "CheckOut",
                           "Timestamp": FieldValue.serverTimestamp(),
                         "requestedTo":(selectedAppointment.ParentUid)!,
                         "isVerified": false,
                           ] as [String : Any]
               
               dbStore.collection("Attendance").document(selectedAppointment.appointmentId).updateData(dict)
               
               dbStore.collection("Appointments").document(selectedAppointment.appointmentId).updateData(["Status": "CheckOut"])
               
               performSegue(withIdentifier: "CheckOut", sender: nil)
          }
          
          
          
         
          
     }
     
    
     @IBAction func smsButtonAction(_ sender: Any) {
     }
     @IBAction func emergencyButtonAction(_ sender: Any) {
     }
}




       //*************** EXTENSION ******************

extension SitterAttendancePopVC: CLLocationManagerDelegate{
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {


          guard let location = locations.first else {return}

          self.currentLocation = location
          self.locationManager.stopUpdatingLocation()

     }
}
