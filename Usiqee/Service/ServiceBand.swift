//
//  ServiceBand.swift
//  Usiqee
//
//  Created by Amine on 07/04/2021.
//

import Foundation

class ServiceBand {
    
    static func getBands(completion: @escaping ([Band]) -> Void) {
        FFirestoreReference.band.getDocuments { (query, error) in
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
        }
    }
}
