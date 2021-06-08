//
//  EventsFilterTableViewHandler.swift
//  Usiqee
//
//  Created by Amine on 28/05/2021.
//

import Foundation

class EventsFilterTableViewHandler: NSObject {
    
    // MARK: - Properties
    var showOnlyFollowed: Bool!
    var events: [SelectedEvent]!
    
    private var numberOfSelectedEvents: Int {
        events.filter({ $0.isSelected }).count
    }
    
    // MARK: - LifeCycle
    override init() {
        super.init()
        setDefaultValues()
    }
    
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
            return .followed(isSelected: showOnlyFollowed)
        case .event:
            return .event(events[indexPath.row])
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
        ManagerEvents.shared.events = events
        ManagerEvents.shared.didUpdateFilter()
    }
    
    func didSelectEvent(at index: Int) {
        if numberOfSelectedEvents == 1,
           events[index].isSelected {
            return
        }
        
        events[index].isSelected.toggle()
    }
    
    private func setDefaultValues() {
        showOnlyFollowed = ManagerEvents.shared.showOnlyFollowed
        events = ManagerEvents.shared.events
    }
}
