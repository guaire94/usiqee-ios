//
//  NewsSection.swift
//  Usiqee
//
//  Created by Quentin Gallois on 01/03/2021.
//  Copyright © 2021 Quentin Gallois. All rights reserved.
//

struct NewsSection: Codable {
    let type: String
    let content: String
    let rank: Int
    var sectionType: MNewsSectionType? {
        switch type {
        case "text":
            return .text(content: content)
        case "ads":
            return .ads
        case "image":
            return .image(url: content)
        case "video":
            return .video(url: content)
        default:
            return nil
        }
    }
}
