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
    let cover: String
    let title: String
    let subtitle: String
    let nbLikes: Int
    let nbComments: Int
    let externalLink: String?
    let date: Timestamp
    
    var toRelated: RelatedNews? {
        guard let id = id else { return nil }
        return RelatedNews(newsId: id, cover: cover, title: title, date: date)
    }
}
