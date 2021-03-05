//
//  User.swift
//  Usiqee
//
//  Created by Quentin Gallois on 21/10/2020.
//

import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var avatar: String
    var mail: String
    var username: String
    var createdDate: Timestamp
}

