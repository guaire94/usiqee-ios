//
//  RelatedArtist.swift
//  Usiqee
//
//  Created by Guaire94 on 04/03/2021.
//

class RelatedArtist: RelatedMusicalEntity {
    
    // MARK: - Private
    private enum CodingKeys: String, CodingKey {
        case artistId
    }
    
    // MARK: - Properties
    var artistId: String
    
    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        artistId = try container.decode(String.self, forKey: .artistId)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(artistId, forKey: .artistId)
    }
}
