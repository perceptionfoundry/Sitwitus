//
//  Attendace.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 10/02/2021.
//  Copyright © 2021 Syed ShahRukh Haider. All rights reserved.
//

import Foundation
import Firebase


struct Attendance: Codable {
var appointmentId : String
     var CreatedBy : String
     var Address : String
     var BookingNumber : String
     var Date : String
     var Time : String
     var Hours : String
     var Lat : Double
     var Long : Double
     var ParentName: String
     var ParentUid: String
     var SitterName: String
     var SitterUid: String
     var SignInTime: Timestamp
     var SignOutTime: Timestamp
     var Status: String
     var Timestamp: Timestamp
     var requestedTo: String
     var isVerified: Bool
}
