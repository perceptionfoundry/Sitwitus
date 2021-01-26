//
//  Appointment.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 26/01/2021.
//  Copyright © 2021 Syed ShahRukh Haider. All rights reserved.
//

import Foundation
import Firebase


struct Appointment: Codable {
     
     var appointmentId : String!
     var CreatedBy : String!
     var Address: String
     var Lat : Double
     var Long : Double
     var ParentName : String!
     var ParentUid : String!
     var ParentImage : String!
     var SitterName : String!
     var SitterUid : String!
     var SitterImage : String!
     var SitterReview : Double!
     var Rate : Double!
     var Tip : Int?
     var Hours : String!
     var Date : String!
     var Time : String!
     var Status : String!
     var Timestamp : Timestamp!
     var requestUid: String!
}
