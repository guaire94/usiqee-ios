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
            ServiceUser.shared.delegate = self
            ServiceUser.shared.setupFollowedArtists(user: user)
            ServiceUser.shared.setupFollowedBands(user: user)
        } else {
            ServiceUser.shared.clear()
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
    
    private func didUpdateFollowedMusicalEntities() {
        self.delegates.forEach {
            $0.didUpdateFollowedEntities()
        }
    }
}

// MARK: - ServiceUserDelegate
extension ManagerAuth: ServiceUserDelegate {
    func dataAdded(artist: RelatedArtist) {
        followedArtists.append(artist)
        didUpdateFollowedMusicalEntities()
    }
    
    func dataModified(artist: RelatedArtist) {
        guard let index = self.followedArtists.firstIndex(where: { $0.id == artist.id }) else { return }
        followedArtists[index] = artist
        didUpdateFollowedMusicalEntities()
    }
    
    func dataRemoved(artist: RelatedArtist) {
        guard let index = self.followedArtists.firstIndex(where: { $0.id == artist.id }) else { return }
        followedArtists.remove(at: index)
        didUpdateFollowedMusicalEntities()
    }
    
    func dataAdded(band: RelatedBand) {
        followedBands.append(band)
        didUpdateFollowedMusicalEntities()
    }
    
    func dataModified(band: RelatedBand) {
        guard let index = self.followedBands.firstIndex(where: { $0.id == band.id }) else { return }
        followedBands[index] = band
        didUpdateFollowedMusicalEntities()
    }
    
    func dataRemoved(band: RelatedBand) {
        guard let index = self.followedBands.firstIndex(where: { $0.id == band.id }) else { return }
        followedBands.remove(at: index)
        didUpdateFollowedMusicalEntities()
    }
}
