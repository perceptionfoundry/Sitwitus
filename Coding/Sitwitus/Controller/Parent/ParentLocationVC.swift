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


class ParentLocationVC: UIViewController {


                                    //******** OUTLETS ***************

 @IBOutlet weak var localMapView : GMSMapView!

                                   //******** VARIABLES *************

     var mapView : GMSMapView?
     var tappedMarker = GMSMarker()
     var locationManager = CLLocationManager()
     var currentLocation : CLLocation!
     
     var signinUser = sharedVariable.signInUser!
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     self.currentLocation = CLLocation(latitude: 0.0, longitude: 0.0)
     
     self.mapCameraAction()
    }


     //*************** GOOGLE MAP CAMERA
          
     func mapCameraAction(){
          
          locationManager.delegate = self
          locationManager.requestAlwaysAuthorization()
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
          
          locationManager.startUpdatingLocation()
          
          localMapView.delegate = self
          
          
//          let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 10.0)
//          self.mapView = GMSMapView.map(withFrame: localMapView.frame, camera: camera)
//          self.mapView?.delegate = self
//          self.localMapView.addSubview(mapView!)
          
          
     }

     
     //*************** GOOGLE MARKER
          
     func mapMarkerAction(){
          
          let marker = GMSMarker()
          
          //          marker.position = CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
          
          marker.position = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
          
          let markerInnerImage =  (UINib.init(nibName: "MapMarkup", bundle: nil).instantiate(withOwner: self, options: nil).first as! MapMarkup)
          
          markerInnerImage.personIamge.sd_setImage(with: URL(string: signinUser.ImageUrl), placeholderImage: UIImage(named: "new_image"), options: .progressiveLoad, completed: nil)
          
          marker.iconView = markerInnerImage
          marker.isDraggable = true
          
          marker.map = self.localMapView!
          
          
     }
     

                                    //*************** OUTLET ACTION ******************
     @IBAction func backButton(){
              self.navigationController?.popViewController(animated: true)
         }

         
     @IBAction func updateButtonAction(){
          
     }

}




                                      //*************** EXTENSION ******************


//****** CORE LOCATION

extension ParentLocationVC: CLLocationManagerDelegate{
     
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
          
          guard let location = locations.first else {return}
          
          self.currentLocation = location
          self.locationManager.stopUpdatingLocation()
          
          
          let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10)

          
          // *********************** Creating Map View ***********************
          self.localMapView!.animate(to: camera)
          
          
          // *********************** Define user current location with Marker: ***********************
          
//          let marker = GMSMarker(position: location.coordinate)

//          marker.tracksViewChanges = true
   
          mapMarkerAction()
     }
   
     
}

//******** GOOGLE MAP
extension ParentLocationVC: GMSMapViewDelegate{
     
     
     class func instanceFromNib() -> MapMarkerView {
          
     return UINib(nibName: "MapMarkerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MapMarkerView
          
     }
     
     
     
//     func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//
//          let location = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
//          tappedMarker = marker
//
//
//          let index = Int(tappedMarker.title!)!
//          print(index)
//
//          infoWindow.removeFromSuperview()
//
//          infoWindow = SitterMainVC.instanceFromNib()
//
//
//          infoWindow.personName.text = sitters[index].FullName
//          infoWindow.personAddress.text = sitters[index].Location
//
//          infoWindow.bookButton.tag = index
//          infoWindow.bookButton.addTarget(self, action: #selector(BookingAction), for: .touchUpInside)
//          infoWindow.center = mapView.projection.point(for: location)
//          infoWindow.center.y = infoWindow.center.y + 360
//          infoWindow.center.x = infoWindow.center.x + 10
//
//          infoWindow.frame.size.width = 225
//          infoWindow.frame.size.height = 150
////
//
//          self.view.addSubview(infoWindow)
//          return false
//
//     }
     
     
     func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
         print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
     print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
     }
     
     func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
         print("didBeginDragging")
          
     
     }
     func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
         print("didDrag")
          
     }
     
     
     
     //Mark: Reverse GeoCoding
     
     func reverseGeocoding(marker: GMSMarker) {
         let geocoder = GMSGeocoder()
         let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
         
         var currentAddress = String()
         
         geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
             if let address = response?.firstResult() {
                 let lines = address.lines! as [String]
                 
                 print("Response is = \(address)")
                 print("Response is = \(lines)")
                 
                 currentAddress = lines.joined(separator: "\n")
                 
             }
             marker.title = currentAddress
             marker.map = self.mapView
         }
     }
//
//     func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//          return UIView()
//     }
     
     
//     func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//
//          self.view.bringSubviewToFront(localMapView)
//          let location = CLLocationCoordinate2D(latitude: tappedMarker.position.latitude, longitude: tappedMarker.position.longitude)
////          infoWindow.center = mapView.projection.point(for: location)
//     }
     
//     func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
////          infoWindow.removeFromSuperview()
//
//     }
     
}

