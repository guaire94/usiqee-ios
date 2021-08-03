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
    let title: String
    let type: String
    let date: Timestamp
    let webLink: String?
    let locationDescription: String?
    let planner: String?
    let cover: String?
    
    var eventType: MEventType? {
        MEventType(rawValue: type)
    }
}
