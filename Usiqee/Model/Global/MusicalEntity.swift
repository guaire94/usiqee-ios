//
//  MusicalEntity.swift
//  Usiqee
//
//  Created by Amine on 21/04/2021.
//

import Firebase
import FirebaseFirestoreSwift

class MusicalEntity: Identifiable, Codable {
    @DocumentID var id: String?
    var avatar: String
    var name: String
    var labelName: String?
    var majorName: String?
    var startActivityDate: Timestamp
}
