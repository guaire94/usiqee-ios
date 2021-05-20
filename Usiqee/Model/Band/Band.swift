//
//  Band.swift
//  Usiqee
//
//  Created by Quentin Gallois on 22/10/2020.
//

import Firebase
import FirebaseFirestoreSwift

class Band: MusicalEntity {
    
    var relatedData: [String : Any] {
        [
            "bandId": id,
            "name": name,
            "avatar": avatar
        ]
    }
}

