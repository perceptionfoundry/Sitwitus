//
//  Users.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 18/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import Foundation


class Users: Codable{
     
     
     var FullName : String!
     var Email : String!
     var Gender : String!
     var Mobile : String!
     var Location : String!
     var Rate : Double!
     var Lat : Double!
     var Long : Double!
     var userId : String!
     var ImageUrl : String!
     
     static var userDetail : Users!
     
}
