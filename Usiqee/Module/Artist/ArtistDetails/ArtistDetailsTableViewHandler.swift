//
//  ArtistDetailsTableViewHandler.swift
//  Usiqee
//
//  Created by Amine on 14/06/2021.
//

import UIKit

enum ArtistDetailsCellType {
    
    enum BioCellType {
        case information
        case label
        case group
    }
    
    case bio(BioCellType)
    case event(event: RelatedEvent)
    case news(news: RelatedNews)
}

protocol ArtistDetailsTableViewHandlerDelegate: AnyObject {
    func reloadData()
    func setEmptyMessage(_ message: String)
    func restore()
}

class ArtistDetailsTableViewHandler {
    
    // MARK: - Properties
    weak var delegate: ArtistDetailsTableViewHandlerDelegate?
    var artist: Artist?
    var tableViewType: ArtistDetailsVC.ContentType = .bio {
        didSet {
            delegate?.reloadData()
        }
    }
    
    var relatedEvents: [RelatedEvent] = [] {
        didSet {
            guard tableViewType == .calendar else { return }
            delegate?.reloadData()
        }
    }
    
    var relatedLabels: [RelatedLabel] = [] {
        didSet {
            guard tableViewType == .bio else { return }
            delegate?.reloadData()
        }
    }
    
    var relatedBands: [RelatedBand] = [] {
        didSet {
            guard tableViewType == .bio else { return }
            delegate?.reloadData()
        }
    }

    var relatedNews: [RelatedNews] = [] {
        didSet {
            guard tableViewType == .news else { return }
            delegate?.reloadData()
        }
    }

    // MARK: - TableView
    func numberOfRows(in section: Int) -> Int {
        switch tableViewType {
        case .news:
            if relatedNews.isEmpty {
                delegate?.setEmptyMessage(L10N.ArtistDetails.News.emptyListMessage)
            } else {
                delegate?.restore()
            }
            
            return relatedNews.count
        case .bio:
            let cellTypes = bioCellTypes()
            if cellTypes.isEmpty {
                delegate?.setEmptyMessage(L10N.ArtistDetails.Bio.emptyListMessage)
            } else {
                delegate?.restore()
            }
            return cellTypes.count
        case .calendar:
            if relatedEvents.isEmpty {
                delegate?.setEmptyMessage(L10N.ArtistDetails.Calendar.emptyListMessage)
            } else {
                delegate?.restore()
            }
            
            return relatedEvents.count
        }
    }
    
    func item(for indexPath: IndexPath) -> ArtistDetailsCellType? {
        switch tableViewType {
        case .news:
            return .news(news: relatedNews[indexPath.row])
        case .bio:
            guard let cellType = bioCellType(at: indexPath) else { return nil }
            return .bio(cellType)
        case .calendar:
            return .event(event: relatedEvents[indexPath.row])
        }
    }
    
    // MARK: - Private
    private func bioCellType(at indexPath: IndexPath) -> ArtistDetailsCellType.BioCellType? {
        let cellTypes = bioCellTypes()
        guard indexPath.row < cellTypes.count else { return nil }
        return cellTypes[indexPath.row]
    }
    
    private func bioCellTypes() -> [ArtistDetailsCellType.BioCellType] {
        guard let artist = artist else { return [] }
        var result: [ArtistDetailsCellType.BioCellType] = []
        
        if artist.hasInformation {
            result.append(.information)
        }
        
        if !relatedLabels.isEmpty {
            result.append(.label)
        }
        
        if !relatedBands.isEmpty {
            result.append(.group)
        }
        
        return result
    }
}
