//
//  RelatedMusicalEntity.swift
//  Usiqee
//
//  Created by Amine on 14/05/2021.
//

import FirebaseFirestoreSwift

class RelatedMusicalEntity: Identifiable, Codable {
    @DocumentID var id: String?
    var avatar: String
    var name: String
}
