//
//  Pending.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 28/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import Foundation
import Firebase


class Pending: Codable {
     
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
     var Status : String!
     var Timestamp : Timestamp!
     var requestUid: String!
}
