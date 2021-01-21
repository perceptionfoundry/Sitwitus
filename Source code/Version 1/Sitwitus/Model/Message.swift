//
//  Message.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 19/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase




class Message: Codable{
    
    var addedOn: Timestamp!
    var chatId : String!
    var roomId : String!
    var senderName: String!
    var recieverName : String!
    var senderImageURL : String!
    var recieverImageURL : String!
    var isRead:Bool!
    var senderId : String!
    var receiverId : String!
    var composerId : String!
    var readerID :String!
    var type: String!
    var context  : String!
    var isDeleted : Bool!
    
}


extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}
