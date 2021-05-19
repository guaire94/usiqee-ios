//
//  RelatedBand.swift
//  Usiqee
//
//  Created by Guaire94 on 04/03/2021.
//

class RelatedBand: RelatedMusicalEntity {
    
    // MARK: - Private
    private enum CodingKeys: String, CodingKey {
        case bandId
    }
    
    // MARK: - Properties
    var bandId: String
    
    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bandId = try container.decode(String.self, forKey: .bandId)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(bandId, forKey: .bandId)
    }
}
