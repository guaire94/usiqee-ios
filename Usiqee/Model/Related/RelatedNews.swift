//
//  RelatedNews.swift
//  Usiqee
//
//  Created by Guaire94 on 04/03/2021.
//

import Firebase

struct RelatedNews: Codable {
    let newsId: String
    let cover: String
    let author: String
    let title: String
    let createdDate: Timestamp
}
