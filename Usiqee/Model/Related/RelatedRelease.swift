//
//  RelatedRelease.swift
//  Usiqee
//
//  Created by Guaire94 on 04/03/2021.
//

import Firebase

struct RelatedRelease: Codable {
    var releaseId: String
    var title: String
    var cover: String
    var type: String
    var createdDate: Timestamp
    
    var releaseType: MReleaseType? {
        MReleaseType(rawValue: type)
    }
}
