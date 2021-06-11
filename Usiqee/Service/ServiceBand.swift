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

class ServiceBand {
    
    // MARK: - Property
    private static var listener: ListenerRegistration?
    private static var eventsListener: ListenerRegistration?
    
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
        guard let user = Auth.auth().currentUser,
              let follower = user.toFollower,
              let bandId = band.id else {
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var didFollowBand: Bool = true
        var didAddFollower: Bool = true
        
        dispatchGroup.enter()
        FFirestoreReference.userFollowedBands(userId: user.uid).addDocument(data: band.toRelated) { error in
            if let error = error {
                didFollowBand = false
                completion(error)
                dispatchGroup.leave()
                return
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        FFirestoreReference.bandFollowers(bandId: bandId).document(user.uid).setData(follower.toRelated, completion: { error in
            if let error = error {
                didAddFollower = false
                completion(error)
                dispatchGroup.leave()
                return
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: .main) {
            guard didAddFollower, didFollowBand else {
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
        
        FFirestoreReference.userFollowedBands(userId: user.uid).document(bandId).delete { error in
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
    
    static func detachRelatedEvents() {
        eventsListener?.remove()
    }
}
