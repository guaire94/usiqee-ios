//
//  ServiceEvents.swift
//  Usiqee
//
//  Created by Amine on 31/05/2021.
//

import Foundation
import Firebase

protocol ServiceEventsDelegate: AnyObject {
    func dataAdded(event: Event)
    func dataModified(event: Event)
    func dataRemoved(event: Event)
}

class ServiceEvents {
    
    // MARK: - Property
    private static var listener: ListenerRegistration?
    
    // MARK: - GET
    static func listenEvents(delegate: ServiceEventsDelegate) {
        listener?.remove()
        let startDate = ManagerEvents.shared.selectedDate
        guard let endDate = startDate.lastMonthDay else {
            return
        }
        
        self.listener = FFirestoreReference.event
        .whereField("date", isGreaterThan: startDate.timestamp)
        .whereField("date", isLessThan: endDate.timestamp)
        .addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let event = try? diff.document.data(as: Event.self) else { return }
                
                switch diff.type {
                case .added:
                    delegate.dataAdded(event: event)
                case .modified:
                    delegate.dataModified(event: event)
                case .removed:
                    delegate.dataRemoved(event: event)
                }
            }
        }
    }
    
    static func getArtistsEvent(eventId: String, completion: @escaping ([RelatedArtist]) -> Void) {
        FFirestoreReference.eventArtists(eventId: eventId).getDocuments() { (querySnapshot, err) in
            var artists: [RelatedArtist] = []
            defer {
                completion(artists)
            }
            
            guard err == nil, let documents = querySnapshot?.documents else {
                return
            }
            for document in documents {
                if let artist = try? document.data(as: RelatedArtist.self) {
                    artists.append(artist)
                }
            }
        }
    }
    
    static func getBandsEvent(eventId: String, completion: @escaping ([RelatedBand]) -> Void) {
        FFirestoreReference.eventBands(eventId: eventId).getDocuments() { (querySnapshot, err) in
            var bands: [RelatedBand] = []
            defer {
                completion(bands)
            }
            
            guard err == nil, let documents = querySnapshot?.documents else {
                return
            }
            for document in documents {
                if let band = try? document.data(as: RelatedBand.self) {
                    bands.append(band)
                }
            }
        }
    }
    
    static func load(eventId: String, completion: @escaping (EventItem?) -> Void) {
        FFirestoreReference.event.document(eventId).getDocument { (document, error) in
            guard let document = document, document.exists,
                  let event = try? document.data(as: Event.self) else {
                completion(nil)
                return
            }
            syncRelated(event: event) { eventItem in
                completion(eventItem)
            }
        }
    }
    
    static func syncRelated(event: Event, completion: @escaping (EventItem) -> Void ) {
        guard let eventId = event.id else { return }
        var relatedArtists: [RelatedArtist] = []
        var relatedBands: [RelatedBand] = []
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        ServiceEvents.getArtistsEvent(eventId: eventId) { (artists) in
            relatedArtists = artists
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        ServiceEvents.getBandsEvent(eventId: eventId) { (bands) in
            relatedBands = bands
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            let item = EventItem(event: event, artists: relatedArtists, bands: relatedBands)
            completion(item)
        }
    }
}
