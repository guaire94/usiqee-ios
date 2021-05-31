//
//  EventsFilterTableViewHandler.swift
//  Usiqee
//
//  Created by Amine on 28/05/2021.
//

import Foundation

class EventsFilterTableViewHandler: NSObject {
    
    // MARK: - Enums
    enum SectionType {
        case followed
        case event
    }
    
    enum CellType {
        case followed(isSelected: Bool)
        case event(SelectedEvent)
    }
    
    // MARK: - Helper
    var numberOfSection: Int {
        guard ManagerAuth.shared.isConnected else {
            return 1
        }
        
        return 2
    }
    
    func sectiontype(at section: Int) -> SectionType? {
        switch section {
        case 0 where ManagerAuth.shared.isConnected:
            return .followed
        case 0 where !ManagerAuth.shared.isConnected,
             1:
            return .event
        default:
            return nil
        }
    }
    
     func item(for indexPath: IndexPath) -> CellType? {
        switch sectiontype(at: indexPath.section) {
        case .followed:
            return .followed(isSelected: ManagerEvents.shared.showOnlyFollowed)
        case .event:
            return .event(ManagerEvents.shared.events[indexPath.row])
        default:
            return nil
        }
    }
    
    func headerTitle(for section: Int) -> String {
        switch sectiontype(at: section) {
        case .event:
            return L10N.EventsFilter.typeFilter
        default:
            return ""
        }
    }
}
