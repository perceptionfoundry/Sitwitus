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
            self.localMapView.addSubview(mapView!)
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
