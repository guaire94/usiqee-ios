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
    case news
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
    
    // MARK: - TableView
    func numberOfRows(in section: Int) -> Int {
        switch tableViewType {
        case .news:
            delegate?.restore()
            return 0
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
            return nil
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
        
        if artist.hasInformationBloc {
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

// MARK: - Artist
private extension Artist {
    var hasInformationBloc: Bool {
        if pseudos == nil, startActivityYear == nil, provenance == nil, birthName == nil, birthDate == nil {
            return false
        }
        return true
    }
}
