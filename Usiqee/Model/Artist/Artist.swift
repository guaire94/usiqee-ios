//
//  Artist.swift
//  Usiqee
//
//  Created by Quentin Gallois on 22/10/2020.
//

import Firebase
import FirebaseFirestoreSwift

class Artist: MusicalEntity {
    // MARK: - Private
    private enum CodingKeys: String, CodingKey {
        case birthName
        case birthDate
    }
    
    // MARK: - Properties
    var birthName: String?
    var birthDate: Timestamp?
    
    var toRelated: [String : Any] {
        [
            "artistId": id,
            "name": name,
            "avatar": avatar
        ]
    }
    
    var hasInformation: Bool {
        if pseudos == nil, startActivityYear == nil, provenance == nil, birthName == nil, birthDate == nil {
            return false
        }
        return true
    }
    
    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        birthName = try container.decodeIfPresent(String.self, forKey: .birthName)
        birthDate = try container.decodeIfPresent(Timestamp.self, forKey: .birthDate)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(birthName, forKey: .birthName)
        try container.encode(birthDate, forKey: .birthDate)
    }
}
