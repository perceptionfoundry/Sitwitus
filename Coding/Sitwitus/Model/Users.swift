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
     var Rate : Double?
     var Lat : Double?
     var Long : Double?
     var UserId : String!
     var ImageUrl : String!
     var UserType : String!
     var ZipCode : String!
     var Star : Double?
     var VideoUrl : String?
     
     
     static var userDetail = Users()
     
}
