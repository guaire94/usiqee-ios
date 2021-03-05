//
//  Language.swift
//  Usiqee
//
//  Created by Guaire94 on 04/03/2021.
//

import FirebaseFirestoreSwift

struct Language: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var icon: String
}
