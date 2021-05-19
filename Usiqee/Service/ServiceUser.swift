//
//  ServiceUser.swift
//  Usiqee
//
//  Created by Amine on 19/05/2021.
//

import Firebase

protocol ServiceUserDelegate: AnyObject {
    func dataAdded(artist: RelatedArtist)
    func dataModified(artist: RelatedArtist)
    func dataRemoved(artist: RelatedArtist)
    func dataAdded(band: RelatedBand)
    func dataModified(band: RelatedBand)
    func dataRemoved(band: RelatedBand)
}

class ServiceUser {
    
    // MARK: - Singleton
    static let shared = ServiceUser()
    private init() {}
    
    // MARK: - Properties
    weak var delegate: ServiceUserDelegate?
    private var followedArtistsListener: ListenerRegistration?
    private var followedBandsListener: ListenerRegistration?
    
    // MARK: - Public
    func setupFollowedArtists(user: FirebaseAuth.User) {
        followedArtistsListener = FFirestoreReference.userFollowedArtists(userId: user.uid).addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let artist = try? diff.document.data(as: RelatedArtist.self) else { return }
                
                switch diff.type {
                case .added:
                    self.delegate?.dataAdded(artist: artist)
                case .modified:
                    self.delegate?.dataModified(artist: artist)
                case .removed:
                    self.delegate?.dataRemoved(artist: artist)
                }
            }
        }
    }
    
    func setupFollowedBands(user: FirebaseAuth.User) {
        followedBandsListener = FFirestoreReference.userFollowedBands(userId: user.uid).addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let band = try? diff.document.data(as: RelatedBand.self) else { return }
                
                switch diff.type {
                case .added:
                    self.delegate?.dataAdded(band: band)
                case .modified:
                    self.delegate?.dataModified(band: band)
                case .removed:
                    self.delegate?.dataRemoved(band: band)
                }
            }
        }
    }
    
    func clear() {
        followedArtistsListener?.remove()
        followedArtistsListener = nil
        followedBandsListener?.remove()
        followedBandsListener = nil
    }
}
