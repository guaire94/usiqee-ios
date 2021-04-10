//
//  ServiceArtist.swift
//  Usiqee
//
//  Created by Guaire94 on 26/03/2021.
//

import Foundation

class ServiceArtist {
    
    static func getArtists(completion: @escaping ([Artist]) -> Void) {
        
        var items = [Artist]()
        for item in ["a", "b", "c", "d", "e", "f", "j", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s"] {
            items.append(Artist(id: nil, avatar: "https://img.lemde.fr/2020/11/18/494/0/8688/4340/1440/720/60/0/7d2c869_856070765-jul-fifou-0888.jpg", name: "\(item) Jul", labelName: nil, majorName: nil, startActivityDate: .init()))
        }
        
        completion(items)
        /*FFirestoreReference.artist.getDocuments { (query, error) in
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
        }*/
    }
}
