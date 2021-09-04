//
//  NewsDetailsTableViewHandler.swift
//  Usiqee
//
//  Created by Amine on 06/07/2021.
//

import UIKit

class NewsDetailsTableViewHandler {
    
    // MARK: - Enums
    private enum Section {
        case overview
        case sections
        case author
        case relatedArtists
    }
    
    enum CellType {
        case overview(news: NewsItem)
        case image(url: String, image: UIImage?)
        case text(content: String)
        case video(videoId: String)
        case ads
        case author(Author, String?)
        case relatedArtists([RelatedMusicalEntity])
    }
    
    // MARK: - Properties
    var news: NewsItem?
    var sections: [NewsSection] = []
    var author: Author?
    var musicalEntities: [RelatedMusicalEntity] = []
    var imagesCache: [String: UIImage] = [:]
    
    // MARK: - Helper
    private var tableViewSections: [Section] {
        var result: [Section] = [.overview]
        
        if !sections.isEmpty {
            result.append(.sections)
        }
        
        if author != nil {
            result.append(.author)
        }
        
        if !musicalEntities.isEmpty {
            result.append(.relatedArtists)
        }
        
        return result
    }
    
    var numberOfSections: Int {
        tableViewSections.count
    }
    
    func numberOfRows(for section:Int) -> Int {
        switch tableViewSections[section] {
        case .sections:
            return sections.count
        default:
            return 1
        }
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        guard let item = item(for: indexPath) else { return 0 }
        
        switch item {
        case .ads:
            return 320
        case .relatedArtists:
            return 233
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
        
        switch tableViewSections[indexPath.section] {
        case .overview:
            return .overview(news: news)
        case .sections:
            let section = sections[indexPath.row]
            
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
        case .author:
            guard let author = author else { return nil }
            return .author(author, news.news.externalLink)
        case .relatedArtists:
            return .relatedArtists(musicalEntities)
        }
    }
    
    func setImage(for indexPath: IndexPath, image: UIImage) {
        let url = sections[indexPath.row].content
        imagesCache[url] = image
    }
    
    var authorSectionIndex: Int? {
        tableViewSections.lastIndex(of: .author)
    }
}
