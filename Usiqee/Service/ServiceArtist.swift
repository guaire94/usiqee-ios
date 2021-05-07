//
//  ServiceArtist.swift
//  Usiqee
//
//  Created by Guaire94 on 26/03/2021.
//

import FirebaseFirestore

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
}
