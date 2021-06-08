//
//  Event.swift
//  Usiqee
//
//  Created by Quentin Gallois on 28/10/2020.
//

import Firebase
import FirebaseFirestoreSwift

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var type: String
    var date: Timestamp
    var webLink: String?
    
    var eventType: MEventType? {
        MEventType(rawValue: type)
    }
}
