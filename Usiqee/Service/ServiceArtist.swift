//
//  ServiceArtist.swift
//  Usiqee
//
//  Created by Guaire94 on 26/03/2021.
//

import Foundation

class ServiceArtist {
    
    static func getArtists(completion: @escaping ([Artist]) -> Void) {
        FFirestoreReference.artist.getDocuments { (query, error) in
            var artists: [Artist] = []
            defer {
                completion(artists)
            }
            guard error == nil, let documents = query?.documents else { return }
            for document in documents {
                if let artist = try? document.data(as: Artist.self) {
                    artists.append(artist)
                }
            }
        }
    }
}
