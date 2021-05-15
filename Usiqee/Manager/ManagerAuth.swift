//
//  ManagerAuth.swift
//  Usiqee
//
//  Created by Quentin Gallois on 27/10/2020.
//

import Firebase

protocol ManagerAuthDelegate: class {
    func didUpdateUserStatus()
    func didUpdateFollowedEntities()
}

class ManagerAuth {
    
    // MARK: - Singleton
    static let shared = ManagerAuth()
    private init() {}
    
    // MARK: - Properties
    private lazy var dispatchGroup = DispatchGroup()
    var user: User?
    private(set) var followedArtists: [RelatedArtist] = []
    private(set) var followedBands: [RelatedBand] = []
    private var likedNews: [RelatedNews] = []

    private var delegates: [ManagerAuthDelegate] = []
    private var followedArtistsListener: ListenerRegistration?
    private var followedBandsListener: ListenerRegistration?
    
    // MARK: - Public
    var isConnected: Bool {
        Auth.auth().currentUser != nil
    }

    func synchronise(completion: @escaping () -> Void) {
        dispatchGroup.enter()
        
        ServiceAuth.getProfile() { user in
            self.user = user
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func clear() {
        try? Auth.auth().signOut()
        user = nil
        followedArtists = []
        followedBands = []
        likedNews = []
        (UIApplication.shared.delegate as? AppDelegate)?.unregisterForRemoteNotifications()
        Messaging.messaging().token { token, _ in
            if let token = token {
                ServiceDeviceToken.shared.unregister(token: token)
            }
        }
        didChangeStatus()
    }
    
    func didChangeStatus() {
        
        if let user = Auth.auth().currentUser {
            setupFollowedArtists(user: user)
            setupFollowedBands(user: user)
        } else {
            cleanListeners()
        }
        
        delegates.forEach {
            $0.didUpdateUserStatus()
        }
    }
    
    func add(delegate: ManagerAuthDelegate) {
        delegates.append(delegate)
    }
    
    func isFollowing(musicalEntity: MusicalEntity) -> Bool {
        guard isConnected else {
            return false
        }
        
        guard musicalEntity is Artist else {
            return followedBands.contains { $0.bandId == musicalEntity.id }
        }
        
        return followedArtists.contains { $0.artistId == musicalEntity.id }
    }
    
    func relatedArtist(by artistId: String) -> RelatedArtist? {
        followedArtists.filter { $0.artistId ==  artistId }.first
    }
    
    func relatedBand(by bandId: String) -> RelatedBand? {
        followedBands.filter { $0.bandId ==  bandId }.first
    }
    
    // MARK: - private
    
    private func setupFollowedArtists(user: FirebaseAuth.User) {
        followedArtistsListener = FFirestoreReference.userFollowedArtists(userId: user.uid).addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let artist = try? diff.document.data(as: RelatedArtist.self) else { return }
                
                switch diff.type {
                case .added:
                    self.followedArtists.append(artist)
                case .modified:
                    guard let index = self.followedArtists.firstIndex(where: { $0.id == artist.id }) else { return }
                    self.followedArtists[index] = artist
                case .removed:
                    guard let index = self.followedArtists.firstIndex(where: { $0.id == artist.id }) else { return }
                    self.followedArtists.remove(at: index)
                }
                
                self.delegates.forEach {
                    $0.didUpdateFollowedEntities()
                }
            }
        }
    }
    
    private func setupFollowedBands(user: FirebaseAuth.User) {
        followedBandsListener = FFirestoreReference.userFollowedBands(userId: user.uid).addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let band = try? diff.document.data(as: RelatedBand.self) else { return }
                
                switch diff.type {
                case .added:
                    self.followedBands.append(band)
                case .modified:
                    guard let index = self.followedBands.firstIndex(where: { $0.id == band.id }) else { return }
                    self.followedBands[index] = band
                case .removed:
                    guard let index = self.followedBands.firstIndex(where: { $0.id == band.id }) else { return }
                    self.followedBands.remove(at: index)
                }
                
                self.delegates.forEach {
                    $0.didUpdateFollowedEntities()
                }
            }
        }
    }
    
    private func cleanListeners() {
        followedArtistsListener?.remove()
        followedArtistsListener = nil
        followedBandsListener?.remove()
        followedBandsListener = nil
    }
}
