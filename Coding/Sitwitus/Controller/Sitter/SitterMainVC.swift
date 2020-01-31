//
//  SitterMainVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 30/01/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import GoogleMaps

class SitterMainVC: UIViewController {


                                    //******** OUTLETS ***************
     
     @IBOutlet weak var localMapView : UIView!


                                   //******** VARIABLES *************
     var mapView : GMSMapView?
     var tappedMarker = GMSMarker()
     
     
//     var infoWindow = MapMarkerView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
     var infoWindow = MapMarkerView()
                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     
     mapCameraAction()
     mapMarkerAction()
     
     
    }

     
//*************** GOOGLE MAP CAMERA
     
     func mapCameraAction(){
          
          let camera = GMSCameraPosition.camera(withLatitude: 34.0522, longitude: -118.2437, zoom: 10.0)
          self.mapView = GMSMapView.map(withFrame: localMapView.bounds, camera: camera)
          self.mapView?.delegate = self
            self.localMapView.addSubview(mapView!)
//          view = mapView
     }
//*************** GOOGLE MARKER
     
     func mapMarkerAction(){
         
          let marker = GMSMarker()
          marker.position = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
          marker.title = "Los Angeles"
          marker.snippet = "USA"
          marker.map = self.mapView!
          
     }

                                    //*************** OUTLET ACTION ******************


}




                                      //*************** EXTENSION ******************

extension SitterMainVC: GMSMapViewDelegate{
     
     
     class func instanceFromNib() -> MapMarkerView {
     return UINib(nibName: "MapMarkerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MapMarkerView    }
     
     func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
          
          let location = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
          tappedMarker = marker
          infoWindow.removeFromSuperview()
          
          infoWindow = SitterMainVC.instanceFromNib()
          infoWindow.personName.text = "shahrukh"
          infoWindow.personAddress.text = "Karachi"
//          infoWindow.bookButton.addTarget(Any?, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
          infoWindow.center = mapView.projection.point(for: location)
          infoWindow.center.y = infoWindow.center.y + 300
          infoWindow.center.x = infoWindow.center.x + 10

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
             infoWindow.removeFromSuperview()    }
     
}
