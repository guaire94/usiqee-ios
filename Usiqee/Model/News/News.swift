//
//  News.swift
//  Usiqee
//
//  Created by Quentin Gallois on 01/03/2021.
//  Copyright © 2021 Quentin Gallois. All rights reserved.
//

import Firebase
import FirebaseFirestoreSwift

struct News: Identifiable, Codable {
    @DocumentID var id: String?
    var cover: String
    var title: String
    var subtitle: String
    var nbLikes: Int
    var nbComments: Int
    var externalLink: String?
    var createdDate: Timestamp
    
//    init?(document: QueryDocumentSnapshot) {
//        let data = document.data()
//
//        guard let id = data["id"] as? String,
//            let cover = data["cover"] as? String,
//            let title = data["title"] as? String,
//            let subtitle = data["subtitle"] as? String,
//            let createdDate = data["createdDate"] as? Timestamp,
//            let updatedDate = data["updatedDate"] as? Timestamp,
//            let lastMessage = data["lastMessage"] as? String else {
//            return nil
//        }
//
//        self.coachId = coachId
//        self.fullname = fullname
//        self.clubLogo = clubLogo
//        self.createdDate = createdDate
//        self.updatedDate = updatedDate
//        self.lastMessage = lastMessage
//        self.unread = data["unread"] as? Bool
//    }
}
