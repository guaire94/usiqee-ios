//
//  Artist.swift
//  Usiqee
//
//  Created by Quentin Gallois on 22/10/2020.
//

import Firebase
import FirebaseFirestoreSwift

class Artist: MusicalEntity {
    
    var relatedData: [String : Any] {
        [
            "artistId": id,
            "name": name,
            "avatar": avatar
        ]
    }
}
