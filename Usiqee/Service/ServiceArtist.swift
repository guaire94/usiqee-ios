//
//  ServiceArtist.swift
//  Usiqee
//
//  Created by Guaire94 on 26/03/2021.
//

import Firebase

protocol ServiceArtistDelegate {
    func dataAdded(artist: Artist)
    func dataModified(artist: Artist)
    func dataRemoved(artist: Artist)
}

protocol ServiceArtistEventsDelegate: AnyObject {
    func dataAdded(event: RelatedEvent)
    func dataModified(event: RelatedEvent)
    func dataRemoved(event: RelatedEvent)
}

class ServiceArtist {
    
    // MARK: - Property
    private static var listener: ListenerRegistration?
    private static var eventsListener: ListenerRegistration?
    
    // MARK: - GET
    static func listenArtists(delegate: ServiceArtistDelegate) {
        listener?.remove()
        ManagerMusicalEntity.shared.clearArtist()
        self.listener = FFirestoreReference.artist.addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let artist = try? diff.document.data(as: Artist.self) else { return }
                
                switch diff.type {
                case .added:
                    delegate.dataAdded(artist: artist)
                    ManagerMusicalEntity.shared.add(artist: artist)
                case .modified:
                    delegate.dataModified(artist: artist)
                    ManagerMusicalEntity.shared.update(artist: artist)
                case .removed:
                    ManagerMusicalEntity.shared.delete(artist: artist)
                    delegate.dataRemoved(artist: artist)
                }
            }
        }
    }
    
    static func follow(artist: Artist, completion: @escaping (Error?) -> Void)  {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        FFirestoreReference.userFollowedArtists(userId: user.uid).addDocument(data: artist.relatedData) { error in
            if let error = error {
                completion(error)
                return
            }
            
            ManagerAuth.shared.synchronise {
                ManagerEvents.shared.didUpdateFilter()
                completion(nil)
            }
        }
    }
    
    static func unfollow(artist: RelatedArtist, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser,
              let artistId = artist.id else {
            return
        }
        
        FFirestoreReference.userFollowedArtists(userId: user.uid).document(artistId).delete { error in
            if let error = error {
                completion(error)
                return
            }
            
            ManagerAuth.shared.synchronise {
                ManagerEvents.shared.didUpdateFilter()
                completion(nil)
            }
        }
    }
    
    static func listenToRelatedEvents(artist: Artist, delegate: ServiceArtistEventsDelegate?) {
        eventsListener?.remove()
        weak var delegate = delegate
        guard let artistId = artist.id,
              let startDate = Date().firstMonthDay else { return }
        
        self.eventsListener = FFirestoreReference.artistEvents(artistId: artistId)
            .whereField("date", isGreaterThan: startDate.timestamp)
            .addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let event = try? diff.document.data(as: RelatedEvent.self) else { return }
                
                switch diff.type {
                case .added:
                    delegate?.dataAdded(event: event)
                case .modified:
                    delegate?.dataModified(event: event)
                case .removed:
                    delegate?.dataRemoved(event: event)
                }
            }
            
        }
    }
    
    static func detachRelatedEvents() {
        eventsListener?.remove()
    }
}
