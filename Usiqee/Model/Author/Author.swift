//
//  Author.swift
//  Usiqee
//
//  Created by Guaire94 on 04/03/2021.
//

import FirebaseFirestoreSwift

struct Author: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var avatar: String
    var desc: String
    var twitterLink: String?
    var fbLink: String?
    var instagramLink: String?
    var youtubeLink: String?
    var webLink: String?
}
