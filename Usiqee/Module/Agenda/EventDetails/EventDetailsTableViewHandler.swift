//
//  EventDetailsTableViewHandler.swift
//  Usiqee
//
//  Created by Amine on 29/07/2021.
//

import UIKit

class EventDetailsTableViewHandler {
    
    // MARK: - Enums
    enum CellType {
        case overview(information: EventDetailsOverview)
        case dateAndLocation(event: Event)
        case cover(url: String)
        case musicalEntitiesList(musicalEntities: [RelatedMusicalEntity])
    }
    
    // MARK: - Constants
    private enum Constants {
        enum Height {
            static let cover: CGFloat = 100
            static let musicalEntitiesList: CGFloat = 95
        }
    }
    
    // MARK: - Properties
    private var rows: [CellType] = []
    var event: EventItem? {
        didSet {
            rows.removeAll()
            
            guard let event = event,
                  let eventType = event.event.eventType else {
                return
            }
            
            // Overview
            var avatar: String?
            var title: String?
            if [.festival, .special].contains(eventType) {
                title = event.event.planner
                avatar = event.event.cover
            } else if let musicalEntity = event.musicalEntity {
                avatar = musicalEntity.avatar
                title = musicalEntity.name
            }
            rows.append(.overview(information: EventDetailsOverview(
                title: title,
                description: event.event.title,
                avatar: avatar,
                type: eventType
            )))
            
            // Cover
            if [.single, .mixtape, .album, .video].contains(eventType),
               let cover = event.event.cover {
                rows.append(.cover(url: cover))
            }
            
            // Musical entites list
            if [.single, .festival, .special, .concert, .showcase, .video].contains(eventType),
               (!event.artists.isEmpty || !event.bands.isEmpty) {
                var musicalEntities: [RelatedMusicalEntity] = [event.artists, event.bands].flatMap({ (element: [RelatedMusicalEntity]) -> [RelatedMusicalEntity] in
                    element
                })
                musicalEntities.sort(by: { $0.name < $1.name })
                rows.append(.musicalEntitiesList(musicalEntities: musicalEntities))
            }
            
            // dateAndLocation
            rows.append(.dateAndLocation(event: event.event))
            
        }
    }
    
    // MARK: - Helper
    var numberOfRows: Int {
        rows.count
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        guard let item = item(for: indexPath) else { return .zero }
        
        switch item {
        case .overview,
             .dateAndLocation:
            return UITableView.automaticDimension
        case .cover:
            return Constants.Height.cover
        case .musicalEntitiesList:
            return Constants.Height.musicalEntitiesList
        }
    }
    
    func item(for indexPath: IndexPath) -> CellType? {
        rows[indexPath.row]
    }
        
    var redirectionButtonText: String? {
        guard let event = event,
              let eventType = event.event.eventType else {
            return nil
        }
        
        switch eventType {
        case .festival, .concert:
            return L10N.EventDetails.buyTicket
        default:
            return L10N.EventDetails.showDetails
        }
    }
}
