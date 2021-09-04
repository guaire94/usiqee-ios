//
//  RelatedNews.swift
//  Usiqee
//
//  Created by Guaire94 on 04/03/2021.
//

import Firebase

struct RelatedNews: Codable {
    var newsId: String
    var cover: String
    var title: String
    var date: Timestamp
    
    var toData: [String : Any] {
        [
            "newsId": newsId,
            "cover": cover,
            "title": title,
            "date": date
        ]
    }
}
