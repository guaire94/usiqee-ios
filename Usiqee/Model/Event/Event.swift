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
    
    var eventType: MEventType? {
        MEventType(rawValue: type)
    }
    
//    init?(document: QueryDocumentSnapshot) {
//        let data: [String: Any] = document.data()
//        guard let title = data["title"] as? String,
//              let description = data["description"] as? String,
//              let type = data["type"] as? String,
//              let nbTeam = data["nbTeam"] as? Int,
//              let date = data["date"] as? Timestamp,
//              let address = data["address"] as? String,
//              let lat = data["lat"] as? Double,
//              let lng = data["lng"] as? Double,
//              let createdDate = data["createdDate"] as? Timestamp else {
//            return nil
//        }
//        self.id = document.documentID
//        self.title = title
//        self.description = description
//        self.type = EventType(rawValue: type)
//        self.nbTeam = nbTeam
//        self.date = date
//        self.address = address
//        self.lat = lat
//        self.lng = lng
//        self.createdDate = createdDate
//    }
}
