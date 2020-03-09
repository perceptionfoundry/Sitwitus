//
//  AlertWindow.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 17/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import Foundation
import UIKit

class AlertWindow{
     
     func simple_Window( Title: String, Message: String, View: UIViewController){
          
          
          let vc = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
          vc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          
          View.present(vc, animated: true, completion: nil)
     
}
     
     
}
