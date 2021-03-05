//
//  Release.swift
//  Usiqee
//
//  Created by Guaire94 on 04/03/2021.
//

import Firebase
import FirebaseFirestoreSwift

struct Release: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var cover: String
    var type: String
    var duration: Int?
    var createdDate: Timestamp
    
    var releaseType: MReleaseType? {
        MReleaseType(rawValue: type)
    }
}
