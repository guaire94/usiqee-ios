//
//  ManagerEvents.swift
//  Usiqee
//
//  Created by Amine on 27/05/2021.
//

import Foundation

typealias SelectedEventType = (event: MEventType, isSelected: Bool)

protocol ManagerEventDelegate: AnyObject {
    func didUpdateEvents()
    func didStartLoading()
    func didFinishLoading()
    func scroll(to section: Int)
}

class ManagerEvents {
    
    // MARK: - Singleton
    static let shared = ManagerEvents()
    private init() {
        selectedDate = Date().firstMonthDay ?? Date()
        showOnlyFollowed = false
        selectedEventTypes = MEventType.allCases.map { ($0, false)  }
    }
    
    // MARK: - Properties
    var showOnlyFollowed: Bool
    var selectedEventTypes: [SelectedEventType]
    var selectedDate: Date
    weak var delegate: ManagerEventDelegate?
    private var isLoading: Bool = false
    
    private var allEvents: [EventItem] = [] {
        didSet {
            filterEvents()
        }
    }
    
    private(set) var eventsByDate: [(date: Date, events: [EventItem])] = [] {
        didSet {
            delegate?.didUpdateEvents()
            if !isLoading {
                delegate?.didFinishLoading()
            }
            
            scrollToEventIfNeeded()
        }
    }
    
    private func scrollToEventIfNeeded() {
        guard let today = Date().withoutTime,
              selectedDate.firstMonthDay == today.firstMonthDay else {
            return
        }
        
        var dateIndex: Int?
        var minDifference: TimeInterval = TimeInterval.greatestFiniteMagnitude
        for i in 0..<eventsByDate.count {
            let difference = today.timeIntervalSince1970 - eventsByDate[i].date.timeIntervalSince1970
            if abs(difference) <= minDifference {
                dateIndex = i
                minDifference = difference
            }
        }
        
        guard let index = dateIndex else { return }
        delegate?.scroll(to: index)
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
    
    func didSelectPreviousMonth() {
        guard let previousMonth = selectedDate.previousMonth else { return }
        
        selectedDate = previousMonth
        reloadData()
    }
    
    var numberOfActiveFilters: Int {
        var filtersCount = selectedEventTypes.filter { $0.isSelected }.count
        
        if showOnlyFollowed {
            filtersCount += 1
        }
        
        return filtersCount
    }
        
    // MARK: - Private
    private func setDefaultValues() {
        showOnlyFollowed = false
        selectedEventTypes = MEventType.allCases.map { ($0, false)  }
    }
    
    private func filterEvents() {
        var activeEventTypes = selectedEventTypes.filter { $0.isSelected }.compactMap { $0.event.rawValue }
        if activeEventTypes.isEmpty {
            activeEventTypes = selectedEventTypes.compactMap { $0.event.rawValue }
        }
        
        var filteredEvents = allEvents.filter { activeEventTypes.contains($0.event.type) }
        
        if ManagerAuth.shared.isConnected, showOnlyFollowed {
            var events: [EventItem] = []
            
            events.append(contentsOf: filteredEvents.filter { item -> Bool in
                ManagerAuth.shared.followedArtists.contains(where: { followedArtist in
                    item.artists
                        .compactMap({ $0.artistId })
                        .contains(followedArtist.artistId)
                })
            })
            
            events.append(contentsOf: filteredEvents.filter { item -> Bool in
                ManagerAuth.shared.followedBands.contains(where: { followedBand in
                    item.bands
                        .compactMap({ $0.bandId })
                        .contains(followedBand.bandId)
                })
            })
            
            filteredEvents = events
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
        isLoading = true
        delegate?.didStartLoading()
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
    
    func notifyEmptyList() {
        isLoading = false
        delegate?.didFinishLoading()
    }
    
    func didFinishLoading() {
        isLoading = false
    }
}
