//
//  ManagerMusicalEntity.swift
//  Usiqee
//
//  Created by Amine on 15/05/2021.
//

import Foundation

class ManagerMusicalEntity {
    
    // MARK: - Singleton
    static let shared = ManagerMusicalEntity()
    private init() {}
    
    // MARK: - Properties
    private var artists: [Artist] = []
    private var bands: [Band] = []
    
    // MARK: - Public
    func add(artist: Artist) {
        artists.append(artist)
    }
    
    func update(artist: Artist) {
        guard let index = artists.firstIndex(where: { $0.id == artist.id }) else { return }
        
        artists[index] = artist
    }
    
    func delete(artist: Artist) {
        guard let index = artists.firstIndex(where: { $0.id == artist.id }) else { return }
        
        artists.remove(at: index)
    }
    
    func clearArtist() {
        artists.removeAll()
    }
    
    func add(band: Band) {
        bands.append(band)
    }
    
    func update(band: Band) {
        guard let index = bands.firstIndex(where: { $0.id == band.id }) else { return }
        
        bands[index] = band
    }
    
    func delete(band: Band) {
        guard let index = bands.firstIndex(where: { $0.id == band.id }) else { return }
        
        bands.remove(at: index)
    }
    
    func clearBands() {
        bands.removeAll()
    }
    
    func getArtist(by artistId: String) -> Artist? {
        artists.first { $0.id == artistId }
    }
    
    func getBand(by bandId: String) -> Band? {
        bands.first { $0.id == bandId }
    }
}
