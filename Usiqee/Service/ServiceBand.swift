//
//  ServiceBand.swift
//  Usiqee
//
//  Created by Amine on 07/04/2021.
//

import Foundation

class ServiceBand {
    
    static func getBands(completion: @escaping ([Band]) -> Void) {
        completion([Band(id: nil, avatar: "https://www.abcdrduson.com/special/annee-rap-2020/wp-content/uploads/2020/10/09-13-organise-1-1536x2150.jpg", name: "13'Organisé", labelName: nil, majorName: nil, startActivityDate: .init())])
        /*FFirestoreReference.band.getDocuments { (query, error) in
            var bands: [Band] = []
            defer {
                completion(bands)
            }
            guard error == nil, let documents = query?.documents else { return }
            for document in documents {
                if let band = try? document.data(as: Band.self) {
                    bands.append(band)
                }
            }
        }*/
    }
}
