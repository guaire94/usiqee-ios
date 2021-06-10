//
//  EventsFilterTableViewHandler.swift
//  Usiqee
//
//  Created by Amine on 28/05/2021.
//

import UIKit

class EventsFilterTableViewHandler: NSObject {
    
    // MARK: - Properties
    var showOnlyFollowed: Bool
    var selectedEventTypes: [selectedEventType]
    
    // MARK: - LifeCycle
    override init() {
        showOnlyFollowed = ManagerEvents.shared.showOnlyFollowed
        selectedEventTypes = ManagerEvents.shared.selectedEventTypes
    }
    
    // MARK: - Enums
    enum SectionType {
        case followed
        case event
    }
    
    enum CellType {
        case followed(isSelected: Bool)
        case event(selectedEventType)
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
    
    func numberOfRows(in section: Int) -> Int {
        switch sectiontype(at: section) {
        case .followed:
            return 1
        case .event:
            return selectedEventTypes.count
        default:
            return 0
        }
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        guard let cellType = item(for: indexPath) else {
            return 0
        }
        
        switch cellType {
        case .followed:
            return EventsFilterSwitchCell.Constants.height
        case .event:
            return EventsFilterEventTypeCell.Constants.height
        }
    }
    
    func item(for indexPath: IndexPath) -> CellType? {
        switch sectiontype(at: indexPath.section) {
        case .followed:
            return .followed(isSelected: showOnlyFollowed)
        case .event:
            return .event(selectedEventTypes[indexPath.row])
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
    
    func reset() {
        ManagerEvents.shared.reset()
        setDefaultValues()
    }
    
    func validate() {
        ManagerEvents.shared.showOnlyFollowed = showOnlyFollowed
        ManagerEvents.shared.selectedEventTypes = selectedEventTypes
        ManagerEvents.shared.didUpdateFilter()
    }
    
    func didSelectEvent(at index: Int) {
        selectedEventTypes[index].isSelected.toggle()
    }
    
    private func setDefaultValues() {
        showOnlyFollowed = ManagerEvents.shared.showOnlyFollowed
        selectedEventTypes = ManagerEvents.shared.selectedEventTypes
    }
}
