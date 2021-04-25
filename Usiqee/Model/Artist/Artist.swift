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
        case groupName
    }
    
    // MARK: - Properties
    var groupName: String?
    
    // MARK: - Codable
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        groupName = try container.decodeIfPresent(String.self, forKey: .groupName)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(groupName, forKey: .groupName)
    }
}
