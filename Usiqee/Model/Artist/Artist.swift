//
//  Artist.swift
//  Usiqee
//
//  Created by Quentin Gallois on 22/10/2020.
//

import Firebase
import FirebaseFirestoreSwift

struct Artist: Identifiable, Codable {
    @DocumentID var id: String?
    var avatar: String
    var name: String
    var labelName: String?
    var majorName: String?
    var startActivityDate: Timestamp
}
