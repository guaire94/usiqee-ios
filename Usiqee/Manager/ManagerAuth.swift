//
//  ManagerAuth.swift
//  Usiqee
//
//  Created by Quentin Gallois on 27/10/2020.
//

import Firebase

class ManagerAuth {
    
    // MARK: - Singleton
    static let shared = ManagerAuth()
    private init() {}
    
    // MARK: - Properties
    private lazy var dispatchGroup = DispatchGroup()
    var user: User?
    private var followedArtists: [RelatedArtist] = []
    private var followedBands: [RelatedBand] = []
    private var likedBands: [RelatedNews] = []

    // MARK: - Public
    var isConnected: Bool {
        Auth.auth().currentUser != nil
    }

    func synchronise(completion: @escaping () -> Void) {
        dispatchGroup.enter()
        
        ServiceAuth.getProfile() { (user) in
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
        likedBands = []
        (UIApplication.shared.delegate as? AppDelegate)?.unregisterForRemoteNotifications()
        Messaging.messaging().token { token, _ in
            if let token = token {
                ServiceDeviceToken.shared.unregister(token: token)
            }
        }
    }
}
