//
//  RelatedEvent.swift
//  Usiqee
//
//  Created by Guaire94 on 04/03/2021.
//

import Firebase

struct RelatedEvent: Codable {
    var eventId: String
    var title: String
    var type: String
    var date: Timestamp
    
    var eventType: MEventType? {
        MEventType(rawValue: type)
    }
}
