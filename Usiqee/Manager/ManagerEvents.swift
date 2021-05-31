//
//  ManagerEvents.swift
//  Usiqee
//
//  Created by Amine on 27/05/2021.
//

import Foundation

typealias SelectedEvent = (event: MEventType, isSelected: Bool)

class ManagerEvents {
    
    // MARK: - Singleton
    static let shared = ManagerEvents()
    private init() {
        resetData()
    }
    
    // MARK: - Properties
    var showOnlyFollowed: Bool!
    var events: [SelectedEvent]!
    private var numberOfSelectedEvents: Int {
        events.filter({ $0.isSelected }).count
    }
    
    //MARK: - Public
    func reset() {
        resetData()
    }
    
    func didSelectEvent(at index: Int) {
        if numberOfSelectedEvents == 1,
           events[index].isSelected {
            return
        }
        
        events[index].isSelected.toggle()
    }
    
    // MARK: - Private
    private func resetData() {
        showOnlyFollowed = false
        events = MEventType.allCases.map { ($0, true)  }
    }
}
