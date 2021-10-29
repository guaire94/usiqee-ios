//
//  ServiceConfig.swift
//  Usiqee
//
//  Created by Guaire94 on 09/10/2021.
//

import FirebaseFirestore

class ServiceConfig {
    
    static func ads(completion: @escaping (AdsConfig?) -> Void) {
        FFirestoreReference.configAds.getDocument { (document, error) in
            guard let document = document, document.exists,
                  let config = try? document.data(as: AdsConfig.self) else {
                completion(nil)
                return
            }
            completion(config)
        }
    }
}
