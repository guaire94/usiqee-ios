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
        static let adOffset: Int = 4
    }
    
    enum SectionType {
        case carousel
        case list
    }
    
    enum CellType {
        case carousel(news: [NewsItem])
        case list(news: NewsItem)
        case ad
    }
    
    // MARK: - Properties
    weak var delegate: NewsTableViewHandlerDelegate?
    var allNews: [NewsItem] = [] {
        didSet {
            listSectionsItems.removeAll()
            for (index, news) in allNews.enumerated() {
                if index != .zero,
                   index % Constants.adOffset == .zero {
                    listSectionsItems.append(.ad)
                }
                listSectionsItems.append(.list(news: news))
            }
        }
    }
    var carouselNews: [NewsItem] = []
    private var listSectionsItems: [CellType] = []
    
    // MARK: - Helper
    var numberOfSection: Int {
        if carouselNews.isEmpty {
            return 1
        }
        
        return 2
    }
    
    func sectiontype(at section: Int) -> SectionType? {
        switch section {
        case 0 where !carouselNews.isEmpty:
            return .carousel
        case 0 where carouselNews.isEmpty,
             1:
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
            return listSectionsItems.count
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
        case .ad:
            return NewsAdCell.Constants.height
        }
    }
    
    func item(for indexPath: IndexPath) -> CellType? {
        guard let sectiontype = sectiontype(at: indexPath.section) else { return nil }
        switch sectiontype {
        case .carousel:
            return .carousel(news: carouselNews)
        case .list:
            return listSectionsItems[indexPath.row]
        }
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        guard case .list = sectiontype(at: indexPath.section),
              indexPath.row == listSectionsItems.count-2 else { return }
        delegate?.shouldLoadMore()
    }
    
    var contentInset: UIEdgeInsets {
        get {
            if numberOfSection == 1 {
                return UIEdgeInsets(top: 40, left: .zero, bottom: .zero, right: .zero)
            }
            
            return .zero
        }
    }
}
