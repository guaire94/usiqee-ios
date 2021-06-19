//
//  BandDetailsTableViewHandler.swift
//  Usiqee
//
//  Created by Amine on 17/06/2021.
//

import UIKit

enum BandDetailsCellType {
    
    enum BioCellType {
        case information
        case label
        case member
    }
    
    case bio(BioCellType)
    case event(event: RelatedEvent)
    case news
}

protocol BandDetailsTableViewHandlerDelegate: AnyObject {
    func reloadData()
    func setEmptyMessage(_ message: String)
    func restore()
}

class BandDetailsTableViewHandler {
    
    // MARK: - Properties
    weak var delegate: BandDetailsTableViewHandlerDelegate?
    var band: Band?
    var tableViewType: BandDetailsVC.ContentType = .bio {
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
    
    var relatedArtists: [RelatedArtist] = [] {
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
    
    func item(for indexPath: IndexPath) -> BandDetailsCellType? {
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
    private func bioCellType(at indexPath: IndexPath) -> BandDetailsCellType.BioCellType? {
        let cellTypes = bioCellTypes()
        guard indexPath.row < cellTypes.count else { return nil }
        return cellTypes[indexPath.row]
    }
    
    private func bioCellTypes() -> [BandDetailsCellType.BioCellType] {
        guard let band = band else { return [] }
        var result: [BandDetailsCellType.BioCellType] = []
        
        if band.hasInformation {
            result.append(.information)
        }
        
        if !relatedLabels.isEmpty {
            result.append(.label)
        }
        
        if !relatedArtists.isEmpty {
            result.append(.member)
        }
        
        return result
    }
}

