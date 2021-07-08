//
//  NewsTableViewHandler.swift
//  Usiqee
//
//  Created by Amine on 30/06/2021.
//

import UIKit

protocol NewsTableViewHandlerDelegate: AnyObject {
    func shouldLoadMore()
}

class NewsTableViewHandler {
    
    // MARK: - Enums
    private enum Constants {
        static let carouselNumberOfItems: Int = 3
    }
    
    enum SectionType {
        case carousel
        case list
    }
    
    enum CellType {
        case carousel(news: [NewsItem])
        case list(news: NewsItem)
    }
    
    // MARK: - Properties
    weak var delegate: NewsTableViewHandlerDelegate?
    
    // MARK: - Helper
    var numberOfSection: Int {
        if ManagerNews.shared.allNews.count <= Constants.carouselNumberOfItems {
            return 1
        }
        
        return 2
    }
    
    func sectiontype(at section: Int) -> SectionType? {
        switch section {
        case 0:
            return .carousel
        case 1:
            return .list
        default:
            return nil
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let sectiontype = sectiontype(at: section) else { return 0 }
        switch sectiontype {
        case .carousel:
            return 1
        case .list:
            let numberOfItems = ManagerNews.shared.allNews.count
            if numberOfItems < Constants.carouselNumberOfItems {
                return 0
            }
            
            return numberOfItems - Constants.carouselNumberOfItems
        }
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        guard let cellType = item(for: indexPath) else {
            return 0
        }
        
        switch cellType {
        case .carousel:
            return NewsCarouselCell.Constants.height
        case .list:
            return NewsCell.Constants.height
        }
    }
    
    func item(for indexPath: IndexPath) -> CellType? {
        guard let sectiontype = sectiontype(at: indexPath.section) else { return nil }
        switch sectiontype {
        case .carousel:
            let endRange: Int = ManagerNews.shared.allNews.count > Constants.carouselNumberOfItems ? Constants.carouselNumberOfItems : ManagerNews.shared.allNews.count
            return .carousel(news: Array(ManagerNews.shared.allNews[0..<endRange]))
        case .list:
            return .list(news: ManagerNews.shared.allNews[indexPath.row+Constants.carouselNumberOfItems])
        }
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        guard case .list = sectiontype(at: indexPath.section),
              indexPath.row == ManagerNews.shared.allNews.count-Constants.carouselNumberOfItems-2 else { return }
        delegate?.shouldLoadMore()
    }
}
