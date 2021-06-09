//
//  ManagerEvents.swift
//  Usiqee
//
//  Created by Amine on 27/05/2021.
//

import Foundation

typealias SelectedEvent = (event: MEventType, isSelected: Bool)

protocol ManagerEventDelegate: AnyObject {
    func didUpdateEvents()
}

struct EventItem {
    var event: Event
    var artists: [RelatedArtist]
    var bands: [RelatedBand]
}

class ManagerEvents {
    
    // MARK: - Singleton
    static let shared = ManagerEvents()
    private init() {
        selectedDate = Date().firstMonthDay ?? Date()
        setDefaultValues()
    }
    
    // MARK: - Properties
    var showOnlyFollowed: Bool!
    var events: [SelectedEvent]!
    var selectedDate: Date
    weak var delegate: ManagerEventDelegate?
    
    private var allEvents: [EventItem] = [] {
        didSet {
            filterEvents()
        }
    }
    
    private(set) var eventsByDate: [(date: Date, events: [EventItem])] = [] {
        didSet {
            delegate?.didUpdateEvents()
        }
    }
    
    //MARK: - Public
    func setupListener() {
        reloadData()
    }
    
    func reset() {
        setDefaultValues()
        filterEvents()
    }
    
    func didUpdateFilter() {
        filterEvents()
    }
    
    func didSelectNextMonth() {
        guard let nextMonth = selectedDate.nextMonth else { return }
        
        selectedDate = nextMonth
        reloadData()
    }
    
    // MARK: - Private
    private func setDefaultValues() {
        showOnlyFollowed = false
        events = MEventType.allCases.map { ($0, false)  }
    }
    
    private func filterEvents() {
        var activeEventTypes = events.filter { $0.isSelected }.compactMap { $0.event.rawValue }
        if activeEventTypes.isEmpty {
            activeEventTypes = events.compactMap { $0.event.rawValue }
        }
        
        var filteredEvents = allEvents.filter { activeEventTypes.contains($0.event.type) }
        
        if ManagerAuth.shared.isConnected, showOnlyFollowed {
            var relatedEvents: [EventItem] = []
            
            relatedEvents.append(contentsOf: filteredEvents.filter { item -> Bool in
                ManagerAuth.shared.followedArtists.contains(where: { followedArtist in
                    item.artists
                        .compactMap({ $0.artistId })
                        .contains(followedArtist.artistId)
                })
            })
            
            relatedEvents.append(contentsOf: filteredEvents.filter { item -> Bool in
                ManagerAuth.shared.followedBands.contains(where: { followedBand in
                    item.bands
                        .compactMap({ $0.bandId })
                        .contains(followedBand.bandId)
                })
            })
            
            filteredEvents = relatedEvents
        }
        
        sort(events: filteredEvents)
    }
    
    private func sort(events: [EventItem]) {
        var sortedEvent: [(date: Date, events: [EventItem])] = []
        let dict = Dictionary(grouping: events, by: { $0.event.date.withoutTime })
        let sortedKeys = Array(dict.keys).sorted(by: { $0.compare($1) == .orderedAscending })
        
        for key in sortedKeys {
            if let events = dict[key] {
                sortedEvent.append((date: key, events: events))
            }
        }
        eventsByDate = sortedEvent
    }
    
    private func reloadData() {
        allEvents.removeAll()
        ServiceEvents.listenEvents(delegate: self)
    }
}

// MARK: - ServiceEventsDelegate
extension ManagerEvents: ServiceEventsDelegate {
    func dataAdded(event: Event) {
        ServiceEvents.syncRelated(event: event, completion: { [weak self] item in
            guard let self = self else { return }
            if item.artists.isEmpty && item.bands.isEmpty {
                return
            }
            self.allEvents.append(item)
        })
    }
    
    func dataModified(event: Event) {
        guard let index = allEvents.firstIndex(where: { $0.event.id == event.id }) else { return }
        ServiceEvents.syncRelated(event: event, completion: { [weak self] item in
            guard let self = self else { return }
            if item.artists.isEmpty && item.bands.isEmpty {
                self.dataRemoved(event: event)
                return
            }
            self.allEvents[index] = item
        })
    }
    
    func dataRemoved(event: Event) {
        guard let index = allEvents.firstIndex(where: { $0.event.id == event.id }) else { return }
        allEvents.remove(at: index)
    }
}
