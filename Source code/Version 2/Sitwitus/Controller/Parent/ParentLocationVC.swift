//
//  ParentLocationVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 24/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import GoogleMaps
import SDWebImage
import Firebase


class ParentLocationVC: UIViewController {


                                    //******** OUTLETS ***************

 @IBOutlet weak var localMapView : GMSMapView!
@IBOutlet weak var userAddress : UILabel!
     @IBOutlet weak var userImage : UIImageView!

                                   //******** VARIABLES *************

     var mapView : GMSMapView?
     var tappedMarker = GMSMarker()
     var locationManager = CLLocationManager()
     var currentLocation : CLLocation!
     
     var signinUser = sharedVariable.signInUser!
     let userMarker = GMSMarker()
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     self.currentLocation = CLLocation(latitude: 0.0, longitude: 0.0)
     self.userAddress.text = signinUser.Location
     self.userImage.sd_setImage(with: URL(string: signinUser.ImageUrl), placeholderImage: UIImage(named: "profile_Image"), options: .progressiveLoad, completed: nil)
     self.mapCameraAction()
    }


     //*************** GOOGLE MAP CAMERA
          
     func mapCameraAction(){
          
          locationManager.delegate = self
          locationManager.requestAlwaysAuthorization()
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
          
          locationManager.startUpdatingLocation()
          
          localMapView.delegate = self
          
          

          
          
     }

     
     //*************** GOOGLE MARKER
          
     func mapMarkerAction(){
          
          
          
          //          marker.position = CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
          
          userMarker.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
          
          let markerInnerImage =  (UINib.init(nibName: "MapMarkup", bundle: nil).instantiate(withOwner: self, options: nil).first as! MapMarkup)
          
          markerInnerImage.personIamge.sd_setImage(with: URL(string: signinUser.ImageUrl), placeholderImage: UIImage(named: "new_image"), options: .progressiveLoad, completed: nil)
          
          userMarker.iconView = markerInnerImage
          userMarker.isDraggable = true
          
          userMarker.map = self.localMapView!
          
          
     }
     

                                    //*************** OUTLET ACTION ******************
     @IBAction func backButton(){
              self.navigationController?.popViewController(animated: true)
         }

         
     @IBAction func updateButtonAction(){
          
          
          print("final coordinate: \(currentLocation.coordinate.latitude) + \(currentLocation.coordinate.longitude)")
          
          let dbStore = Firestore.firestore()
          
          let updateDict = ["Lat":currentLocation.coordinate.latitude,
                            "Long":currentLocation.coordinate.longitude]
          
          
          
          var userDetail = UserDefaults.standard.dictionary(forKey: "SIGN_DETAIL")!
          
          userDetail["Lat"] = currentLocation.coordinate.latitude
          userDetail["Long"] = currentLocation.coordinate.latitude
          
          
          UserDefaults.standard.set(userDetail, forKey: "SIGN_DETAIL")
          
           let usr = Users.userDetail
          
          
          usr.Lat = currentLocation.coordinate.latitude
          usr.Long = currentLocation.coordinate.longitude
          
          
          dbStore.collection("Users").document(signinUser.UserId).updateData(updateDict)
          
          self.navigationController?.popViewController(animated: true)
     }

}




                                      //*************** EXTENSION ******************


//****** CORE LOCATION

extension ParentLocationVC: CLLocationManagerDelegate{
     
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
          
          guard let location = locations.first else {return}
          
          self.currentLocation = location
          self.locationManager.stopUpdatingLocation()
          
          
          let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)

          
          // *********************** Creating Map View ***********************
          self.localMapView!.animate(to: camera)
          
          
          // *********************** Define user current location with Marker: ***********************
   
          mapMarkerAction()
     }
   
     
}

//******** GOOGLE MAP
extension ParentLocationVC: GMSMapViewDelegate{
     
     
     class func instanceFromNib() -> MapMarkerView {
          
     return UINib(nibName: "MapMarkerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MapMarkerView
          
     }
     

     func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
          
          print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
          
          self.currentLocation = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
          
          return true
     }
     
     func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {

          
          print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
          
          self.currentLocation = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
     }
     
     func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
         print("didBeginDragging")
          

          
          
     
     }
     func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
         print("didDrag")
          
     }

     
}

