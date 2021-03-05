//
//  NewsSection.swift
//  Usiqee
//
//  Created by Quentin Gallois on 01/03/2021.
//  Copyright © 2021 Quentin Gallois. All rights reserved.
//

struct NewsSection: Codable {
    var type: String
    var content: String
    var sectionType: MNewsSectionType? {
        switch type {
        case "text":
            return .text(content: content)
        case "ads":
            return .ads(link: content)
        case "image":
            return .image(url: content)
        case "video":
            return .video(url: content)
        default:
            return nil
        }
    }
}
