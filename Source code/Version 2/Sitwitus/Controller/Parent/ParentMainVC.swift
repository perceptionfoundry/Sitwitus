//
//  ParentMainVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 10/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import CodableFirebase
import SDWebImage



class ParentMainVC: UIViewController {


                                    //******** OUTLETS ***************
     
     @IBOutlet weak var localMapView : UIView!
     @IBOutlet weak var locationTF : UITextField!
     @IBOutlet weak var zipTF : UITextField!
     @IBOutlet weak var childrenTF : UITextField!


                                   //******** VARIABLES *************
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
     var mainMapView : GMSMapView?
     var tappedMarker = GMSMarker()
     var locationManager = CLLocationManager()
     var currentLocation : CLLocation!
     
     
//     var infoWindow = MapMarkerView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
     var infoWindow = MapMarkerView()
     
     var dbStore = Firestore.firestore()
     var sitters = [Users]()
     var originalSitter = [Users]()
     var selectedIndex = -1
     var signInUser = sharedVariable.signInUser!
     
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

     
    
//         print(sharedVariable.signInUser?.Email)
     
     locationTF.delegate = self
     zipTF.delegate = self
     childrenTF.delegate = self
//     locationTF.delegate = self
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     
 
     if signInUser.Lat! == 0.0 && signInUser.Long! == 0.0{

          let alert = UIAlertController(title: "COORDINATE", message: "Please update your exact coordinate", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "UPDATE", style: .destructive, handler: { (action) in

               let storyBoard = UIStoryboard(name: "Parent", bundle: nil)
               let vc = storyBoard.instantiateViewController(identifier: "MAP")

               self.navigationController?.pushViewController(vc, animated: true)

          }))

          self.present(alert, animated: true, completion: nil)
     }
     else{

     }

     locationTF.addTarget(self, action: #selector(searchLocation(_:)), for: .editingChanged)
     zipTF.addTarget(self, action: #selector(searchZip(_:)), for: .editingChanged)
     mainMapView?.clear()
          
     mapCameraAction()
//     mapMarkerAction()
     
     fetchSitter()
     
     
    }
     
     //********** FETCH SITTER LIST
     
     func fetchSitter(){
          
          
          dbStore.collection("Users").getDocuments { (sitterSnap, sitterErr) in
               
               guard  let fetchData = sitterSnap?.documents else{return}
               
//               var count = 0
               
               fetchData.forEach { (value) in
                    
                    let dict = value.data()
                    
                    let sitterInfo = try! FirebaseDecoder().decode(Users.self, from: dict)
                    
                    
                    
                    if sitterInfo.UserType == "Sitter"{
                    self.originalSitter.append(sitterInfo)
                         
                         self.sitters = self.originalSitter
                         
                         self.populateSitterMarker()
//                    self.sitters.append(sitterInfo)
//
//                    self.mapMarkerAction(lat: sitterInfo.Lat!, long: sitterInfo.Long!, ImageString: sitterInfo.ImageUrl, indexNumber: count)
//                    count += 1
                         
                         
                    }
               }
          }
          
     }

  func populateSitterMarker(){
          
          mainMapView?.clear()
          var count = 0
          
          sitters.forEach { (sitter) in
               self.sitters.append(sitter)
                    
               self.mapMarkerAction(lat: sitter.Lat!, long: sitter.Long!, ImageString: sitter.ImageUrl, indexNumber: count)
               count += 1
          }
     }
   
     
     
//*************** GOOGLE MAP CAMERA
     
     func mapCameraAction(){
          
          locationManager.delegate = self
          locationManager.requestAlwaysAuthorization()
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
          
          locationManager.startUpdatingLocation()
          
          
          let camera = GMSCameraPosition.camera(withLatitude: 34.0522, longitude: -118.2437, zoom: 15.0)
          self.mainMapView = GMSMapView.map(withFrame: localMapView.bounds, camera: camera)
          self.mainMapView?.delegate = self
          self.localMapView.addSubview(mainMapView!)
//          view = mapView
     }
//*************** GOOGLE MARKER
     
     func mapMarkerAction(lat: Double, long: Double, ImageString: String,indexNumber: Int){
         
          let marker = GMSMarker()
          
          //          marker.position = CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
          
          marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
          marker.title = "\(indexNumber)"
          
          let markerInnerImage =  (UINib.init(nibName: "MapMarkup", bundle: nil).instantiate(withOwner: self, options: nil).first as! MapMarkup)
          
          markerInnerImage.personIamge.sd_setImage(with: URL(string: ImageString), placeholderImage: UIImage(named: "new_image"), options: .progressiveLoad, completed: nil)
          
          
          marker.iconView = markerInnerImage
          marker.map = self.mainMapView!
          
     }

     
     @objc func searchLocation(_ textField: UITextField){
          self.sitters.removeAll()
          
          self.mainMapView?.clear()
          
          if textField.text?.count != 0{

               originalSitter.forEach { (sitter) in
                    if let sitterSearch = textField.text{
                         let range = sitter.Location.lowercased().range(of: sitterSearch, options: .caseInsensitive, range: nil, locale: nil)
                         if range != nil{
                              self.sitters.append(sitter)
                         }
                    }
               }
          }else{
               self.sitters = self.originalSitter
          }
          
          self.populateSitterMarker()
     }
     
     
     @objc func searchZip(_ textField: UITextField){
          self.sitters.removeAll()
          
          self.mainMapView?.clear()
          
          if textField.text?.count != 0{

               originalSitter.forEach { (sitter) in
                    if let sitterSearch = textField.text{
                         let range = sitter.ZipCode.lowercased().range(of: sitterSearch, options: .caseInsensitive, range: nil, locale: nil)
                         if range != nil{
                              self.sitters.append(sitter)
                         }
                    }
               }
          }else{
               self.sitters = self.originalSitter
          }
          
          self.populateSitterMarker()
     }
     
     
     
     @objc func searchchildren(_ textField: UITextField){
          self.sitters.removeAll()
          
          self.mainMapView?.clear()
          
          if textField.text?.count != 0{

               originalSitter.forEach { (sitter) in
                    if let sitterSearch = textField.text{
                         let range = sitter.Mobile.lowercased().range(of: sitterSearch, options: .caseInsensitive, range: nil, locale: nil)
                         if range != nil{
                              self.sitters.append(sitter)
                         }
                    }
               }
          }else{
               self.sitters = self.originalSitter
          }
          
          self.populateSitterMarker()
     }
     
     @objc func BookingAction(button: UIButton){
          
          print(button.tag)
          
          self.selectedIndex = button.tag
          performSegue(withIdentifier: "Booking_Segue", sender: nil)
     }
     
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
          
          if segue.identifier == "Booking_Segue"{
          let dest = segue.destination  as! ParentBookingVC
          
          dest.sitter = sitters[self.selectedIndex]
          }
     }
                                    //*************** OUTLET ACTION ******************


}




                                      //*************** EXTENSION ******************

//****** CORE LOCATION

extension ParentMainVC: CLLocationManagerDelegate{
     
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
          
          guard let location = locations.first else {return}
          
          self.currentLocation = location
          self.locationManager.stopUpdatingLocation()
          
          
          let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 12)

          
          // *********************** Creating Map View ***********************
          mainMapView!.animate(to: camera)
          
          // *********************** Define user current location with Marker: ***********************
          
//          let marker = GMSMarker(position: location.coordinate)

//          marker.tracksViewChanges = true
   
//          mapMarkerAction()
     }
   
     
}

//******** GOOGLE MAP
extension ParentMainVC: GMSMapViewDelegate{
     
     
     class func instanceFromNib() -> MapMarkerView {
     return UINib(nibName: "MapMarkerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MapMarkerView
          
     }
     
     
     
     func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
          
          let location = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
          tappedMarker = marker
          
          
          let index = Int(tappedMarker.title!)!
          print(index)
          
          infoWindow.removeFromSuperview()
          
          infoWindow = SitterMainVC.instanceFromNib()
          
          
          infoWindow.personName.text = sitters[index].FullName
          infoWindow.personAddress.text = sitters[index].Location
          
          infoWindow.bookButton.tag = index
          infoWindow.bookButton.addTarget(self, action: #selector(BookingAction), for: .touchUpInside)
          
          
          infoWindow.center = self.mainMapView!.projection.point(for: location)
          infoWindow.center.y = infoWindow.center.y + 250
//          infoWindow.center.x = infoWindow.center.x + 100

          infoWindow.frame.size.width = 225
          infoWindow.frame.size.height = 150
//
     
          self.view.addSubview(infoWindow)
          return false

     }
     
     
     
     func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
          return UIView()
     }
     
     
     func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
         
          self.view.bringSubviewToFront(localMapView)
          let location = CLLocationCoordinate2D(latitude: tappedMarker.position.latitude, longitude: tappedMarker.position.longitude)
          infoWindow.center = mapView.projection.point(for: location)
     }
     
     func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
          infoWindow.removeFromSuperview()
          
     }
     
}


extension ParentMainVC: UITextFieldDelegate{
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
     }
}
