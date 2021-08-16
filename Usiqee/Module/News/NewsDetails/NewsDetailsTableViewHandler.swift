//
//  NewsDetailsTableViewHandler.swift
//  Usiqee
//
//  Created by Amine on 06/07/2021.
//

import UIKit

class NewsDetailsTableViewHandler {
    
    // MARK: - Enums
    
    enum CellType {
        case overview(news: NewsItem)
        case image(url: String, image: UIImage?)
        case text(content: String)
        case video(videoId: String)
        case ads
        case author(Author, String?)
    }
    
    // MARK: - Properties
    var news: NewsItem?
    var sections: [NewsSection] = []
    var author: Author?
    var imagesCache: [String: UIImage] = [:]
    
    // MARK: - Helper
    var numberOfRows: Int {
        var result = sections.count+1
        
        if author != nil {
            result += 1
        }
        
        return result
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        guard let item = item(for: indexPath) else { return 0 }
        
        switch item {
        case .ads:
            return 320
        case .overview,
             .image,
             .text,
             .video,
             .author:
            return UITableView.automaticDimension
        }
    }
    
    func item(for indexPath: IndexPath) -> CellType? {
        guard let news = news else { return nil }
        
        guard indexPath.row > 0 else {
            return .overview(news: news)
        }
        
        if indexPath.row > sections.count {
            guard let author = author else {
                return nil
            }
            return .author(author, news.news.externalLink)
        }
        
        let section = sections[indexPath.row-1]
        
        guard let sectionType = section.sectionType else { return nil }
        switch sectionType {
        case let .text(content: content):
            return .text(content: content)
        case let .image(url: url):
            return .image(url: url, image: imagesCache[url])
        case .ads:
            return .ads
        case let .video(url: videoId):
            return .video(videoId: videoId)
        }
    }
    
    func setImage(for indexPath: IndexPath, image: UIImage) {
        let url = sections[indexPath.row-1].content
        imagesCache[url] = image
    }
}
