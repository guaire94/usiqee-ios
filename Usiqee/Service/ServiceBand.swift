//
//  ServiceBand.swift
//  Usiqee
//
//  Created by Amine on 07/04/2021.
//

import Firebase

protocol ServiceBandDelegate {
    func dataAdded(band: Band)
    func dataModified(band: Band)
    func dataRemoved(band: Band)
}

protocol ServiceBandEventsDelegate: AnyObject {
    func dataAdded(event: RelatedEvent)
    func dataModified(event: RelatedEvent)
    func dataRemoved(event: RelatedEvent)
}

protocol ServiceBandLabelsDelegate: AnyObject {
    func dataAdded(label: RelatedLabel)
    func dataModified(label: RelatedLabel)
    func dataRemoved(label: RelatedLabel)
}

protocol ServiceBandMembersDelegate: AnyObject {
    func dataAdded(artist: RelatedArtist)
    func dataModified(artist: RelatedArtist)
    func dataRemoved(artist: RelatedArtist)
}

class ServiceBand {
    
    // MARK: - Property
    private static var listener: ListenerRegistration?
    private static var eventsListener: ListenerRegistration?
    private static var labelsListener: ListenerRegistration?
    private static var membersListener: ListenerRegistration?
    
    // MARK: - GET
    static func listenBands(delegate: ServiceBandDelegate) {
        listener?.remove()
        ManagerMusicalEntity.shared.clearBands()
        listener = FFirestoreReference.band.addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let band = try? diff.document.data(as: Band.self) else { return }
                
                switch diff.type {
                case .added:
                    delegate.dataAdded(band: band)
                    ManagerMusicalEntity.shared.add(band: band)
                case .modified:
                    delegate.dataModified(band: band)
                    ManagerMusicalEntity.shared.update(band: band)
                case .removed:
                    delegate.dataRemoved(band: band)
                    ManagerMusicalEntity.shared.delete(band: band)
                }
            }
        }
    }
    
    static func follow(band: Band, completion: @escaping (Error?) -> Void)  {
        guard let userId = Auth.auth().currentUser?.uid,
              let follower = ManagerAuth.shared.user?.toFollower,
              let bandId = band.id else {
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var hasError: Bool = false
        
        dispatchGroup.enter()
        FFirestoreReference.userFollowedBands(userId: userId).addDocument(data: band.toRelated) { error in
            if let error = error {
                hasError = true
                completion(error)
                dispatchGroup.leave()
                return
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        FFirestoreReference.bandFollowers(bandId: bandId).document(userId).setData(follower.toData, completion: { error in
            if let error = error {
                hasError = true
                completion(error)
                dispatchGroup.leave()
                return
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: .main) {
            guard !hasError else {
                return
            }
            
            ManagerAuth.shared.synchronise {
                ManagerEvents.shared.didUpdateFilter()
                completion(nil)
            }
        }
    }
    
    static func unfollow(band: RelatedBand, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser,
              let bandId = band.id else {
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var hasError: Bool = false
        
        dispatchGroup.enter()
        FFirestoreReference.userFollowedBands(userId: user.uid).document(bandId).delete { error in
            if let error = error {
                hasError = true
                completion(error)
                dispatchGroup.leave()
                return
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        FFirestoreReference.bandFollowers(bandId: band.bandId).document(user.uid).delete { error in
            if let error = error {
                hasError = true
                completion(error)
                dispatchGroup.leave()
                return
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            guard !hasError else {
                return
            }
            
            ManagerAuth.shared.synchronise {
                ManagerEvents.shared.didUpdateFilter()
                completion(nil)
            }
        }
    }
    
    static func listenToRelatedEvents(band: Band, delegate: ServiceBandEventsDelegate?) {
        eventsListener?.remove()
        weak var delegate = delegate
        guard let bandId = band.id,
              let startDate = Date().withoutTime else { return }
        
        eventsListener = FFirestoreReference.bandEvents(bandId: bandId)
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
    
    static func listenToRelatedLabels(band: Band, delegate: ServiceBandLabelsDelegate?) {
        labelsListener?.remove()
        weak var delegate = delegate
        guard let bandId = band.id else { return }
        
        labelsListener = FFirestoreReference.bandLabels(bandId: bandId)
            .addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let label = try? diff.document.data(as: RelatedLabel.self) else { return }
                
                switch diff.type {
                case .added:
                    delegate?.dataAdded(label: label)
                case .modified:
                    delegate?.dataModified(label: label)
                case .removed:
                    delegate?.dataRemoved(label: label)
                }
            }
        }
    }
    
    static func listenToRelatedMembers(band: Band, delegate: ServiceBandMembersDelegate?) {
        membersListener?.remove()
        weak var delegate = delegate
        guard let bandId = band.id else { return }
        
        membersListener = FFirestoreReference.bandArtists(bandId: bandId)
            .addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let artist = try? diff.document.data(as: RelatedArtist.self) else { return }
                
                switch diff.type {
                case .added:
                    delegate?.dataAdded(artist: artist)
                case .modified:
                    delegate?.dataModified(artist: artist)
                case .removed:
                    delegate?.dataRemoved(artist: artist)
                }
            }
        }
    }
    
    static func detachRelatedListeners() {
        eventsListener?.remove()
        labelsListener?.remove()
        membersListener?.remove()
    }
}
