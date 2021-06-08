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
}
