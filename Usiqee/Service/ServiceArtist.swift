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

protocol ServiceArtistLabelsDelegate: AnyObject {
    func dataAdded(label: RelatedLabel)
    func dataModified(label: RelatedLabel)
    func dataRemoved(label: RelatedLabel)
}

protocol ServiceArtistBandsDelegate: AnyObject {
    func dataAdded(band: RelatedBand)
    func dataModified(band: RelatedBand)
    func dataRemoved(band: RelatedBand)
}

protocol ServiceArtistNewsDelegate: AnyObject {
    func dataAdded(news: RelatedNews)
    func dataModified(news: RelatedNews)
    func dataRemoved(news: RelatedNews)
}

class ServiceArtist {
    
    // MARK: - Property
    private static var listener: ListenerRegistration?
    private static var eventsListener: ListenerRegistration?
    private static var labelsListener: ListenerRegistration?
    private static var bandsListener: ListenerRegistration?
    private static var newsListener: ListenerRegistration?

    // MARK: - GET
    static func listenArtists(delegate: ServiceArtistDelegate) {
        listener?.remove()
        ManagerMusicalEntity.shared.clearArtist()
        listener = FFirestoreReference.artist.addSnapshotListener { query, error in
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
        guard let userId = Auth.auth().currentUser?.uid,
              let follower = ManagerAuth.shared.user?.toFollower,
              let artistId = artist.id else {
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var hasError: Bool = false
        
        dispatchGroup.enter()
        FFirestoreReference.userFollowedArtists(userId: userId).addDocument(data: artist.toRelated) { error in
            if let error = error {
                hasError = true
                completion(error)
                dispatchGroup.leave()
                return
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        FFirestoreReference.artistFollowers(artistId: artistId).document(userId).setData(follower.toData, completion: { error in
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
    
    static func unfollow(artist: RelatedArtist, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser,
              let artistId = artist.id else {
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var hasError: Bool = false
        
        dispatchGroup.enter()
        FFirestoreReference.userFollowedArtists(userId: user.uid).document(artistId).delete { error in
            if let error = error {
                hasError = true
                completion(error)
                dispatchGroup.leave()
                return
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        FFirestoreReference.artistFollowers(artistId: artist.artistId).document(user.uid).delete { error in
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
    
    static func listenToRelatedEvents(artist: Artist, delegate: ServiceArtistEventsDelegate?) {
        eventsListener?.remove()
        weak var delegate = delegate
        guard let artistId = artist.id,
              let startDate = Date().withoutTime else { return }
        
        eventsListener = FFirestoreReference.artistEvents(artistId: artistId)
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
    
    static func listenToRelatedLabels(artist: Artist, delegate: ServiceArtistLabelsDelegate?) {
        labelsListener?.remove()
        weak var delegate = delegate
        guard let artistId = artist.id else { return }
        
        labelsListener = FFirestoreReference.artistLabels(artistId: artistId)
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
    
    static func listenToRelatedBand(artist: Artist, delegate: ServiceArtistBandsDelegate?) {
        bandsListener?.remove()
        weak var delegate = delegate
        guard let artistId = artist.id else { return }
        
        bandsListener = FFirestoreReference.artistBands(artistId: artistId)
            .addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let band = try? diff.document.data(as: RelatedBand.self) else { return }
                
                switch diff.type {
                case .added:
                    delegate?.dataAdded(band: band)
                case .modified:
                    delegate?.dataModified(band: band)
                case .removed:
                    delegate?.dataRemoved(band: band)
                }
            }
        }
    }

    static func listenToRelatedNews(artist: Artist, delegate: ServiceArtistNewsDelegate?) {
        newsListener?.remove()
        weak var delegate = delegate
        guard let artistId = artist.id else { return }
        
        newsListener = FFirestoreReference.artistNews(artistId: artistId)
            .addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let news = try? diff.document.data(as: RelatedNews.self) else { return }
                
                switch diff.type {
                case .added:
                    delegate?.dataAdded(news: news)
                case .modified:
                    delegate?.dataModified(news: news)
                case .removed:
                    delegate?.dataRemoved(news: news)
                }
            }
        }
    }

    static func detachRelatedListeners() {
        eventsListener?.remove()
        labelsListener?.remove()
        bandsListener?.remove()
        newsListener?.remove()
    }
    
    static func getArtist(artistId: String, completion: @escaping (Artist?) -> Void) {
        FFirestoreReference.artist.document(artistId).getDocument { document, error in
            guard let document = document, document.exists,
                  let artist = try? document.data(as: Artist.self) else {
                completion(nil)
                return
            }
            completion(artist)
        }
    }
}
