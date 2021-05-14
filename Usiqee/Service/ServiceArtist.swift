//
//  ServiceArtist.swift
//  Usiqee
//
//  Created by Guaire94 on 26/03/2021.
//

import FirebaseFirestore
import Firebase

protocol ServiceArtistDelegate {
    func dataAdded(artist: Artist)
    func dataModified(artist: Artist)
    func dataRemoved(artist: Artist)
}

class ServiceArtist {
    
    // MARK: - Property
    private static var listener: ListenerRegistration?
    
    // MARK: - GET
    static func listenArtists(delegate: ServiceArtistDelegate) {
        listener?.remove()
        self.listener = FFirestoreReference.artist.addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let artist = try? diff.document.data(as: Artist.self) else { return }
                
                switch diff.type {
                case .added:
                    delegate.dataAdded(artist: artist)
                case .modified:
                    delegate.dataModified(artist: artist)
                case .removed:
                    delegate.dataRemoved(artist: artist)
                }
            }
        }
    }
    
    static func follow(artist: Artist, completion: @escaping (Error?) -> Void)  {
        guard let user = Auth.auth().currentUser else {
            return
        }
        let data: [String : Any] = [
            "artistId": artist.id,
            "name": artist.name,
            "avatar": artist.avatar
        ]
        FFirestoreReference.userFollowedArtists(userId: user.uid).addDocument(data: data) { error in
            if let error = error {
                completion(error)
                return
            }
            
            ManagerAuth.shared.synchronise {
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
                completion(nil)
            }
        }
    }
}
