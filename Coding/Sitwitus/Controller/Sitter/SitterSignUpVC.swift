//
//  SitterSignUpVC.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 28/01/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import LocationPickerViewController


class SitterSignUpVC: UIViewController {


                                    //******** OUTLETS ***************
     
     @IBOutlet weak var LocationTF : UITextField!


                                   //******** VARIABLES *************

                                   
                                   //********* FUNCTIONS ***************
    
    
//******* VIEW FUNCTIONS

 override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
     
     LocationTF.delegate = self
    }



                                    //*************** OUTLET ACTION ******************


}




                                      //*************** EXTENSION ******************
extension SitterSignUpVC: UITextFieldDelegate{
     
     func textFieldDidBeginEditing(_ textField: UITextField) {
          
          if textField == LocationTF{
               
               LocationTF.resignFirstResponder()
               
               let locationPicker = LocationPicker()
               locationPicker.delegate = self
               
               
              let done = locationPicker.barButtonItems?.doneButtonItem
              let cancel = locationPicker.barButtonItems?.cancelButtonItem
               
               locationPicker.addBarButtons(doneButtonItem: done, cancelButtonItem: cancel, doneButtonOrientation: .right)
               
//               locationPicker.addBarButtons()
              
               locationPicker.pickCompletion = { (pickedLocationItem) in
                   
                    print(pickedLocationItem.addressDictionary)
               }
               navigationController!.pushViewController(locationPicker, animated: true)
          }
     }
     
}

extension SitterSignUpVC: LocationPickerDelegate{
    
     
     func locationDidPick(locationItem: LocationItem) {
          print("PICK")
     }
     
     
     func locationDidSelect(locationItem: LocationItem) {

          LocationTF.text = locationItem.name
          print(locationItem.coordinate)
          
          
          let alertVC = UIAlertController(title: "Pin Drop", message: "Do you want to pin drop to exact location", preferredStyle: .alert)
          
          let Pin = UIAlertAction(title: "Pin Drop", style: .default, handler: nil)
          let Select = UIAlertAction(title: "Done", style: .default) { (action) in
               
               self.LocationTF.text = locationItem.name
                    print(locationItem.coordinate)
               self.navigationController?.popViewController(animated: true)

          }
          
          alertVC.addAction(Pin)
          alertVC.addAction(Select)
          
          self.present(alertVC, animated: true, completion: nil)
     }
     
     
  
}
