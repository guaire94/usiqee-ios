//
//  ArtistBandBase.swift
//  Usiqee
//
//  Created by Amine on 21/04/2021.
//

import Firebase
import FirebaseFirestoreSwift

class ArtistBandBase: Identifiable, Codable {
    @DocumentID var id: String?
    var avatar: String
    var name: String
    var labelName: String?
    var majorName: String?
    var groupName: String?
    var startActivityDate: Timestamp
}
