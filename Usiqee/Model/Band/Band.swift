//
//  Band.swift
//  Usiqee
//
//  Created by Quentin Gallois on 22/10/2020.
//

import Firebase
import FirebaseFirestoreSwift

class Band: MusicalEntity {
    
    var toRelated: [String : Any] {
        [
            "bandId": id,
            "name": name,
            "avatar": avatar
        ]
    }
    
    var hasInformation: Bool {
        if pseudos == nil, startActivityYear == nil, provenance == nil {
            return false
        }
        return true
    }
}

