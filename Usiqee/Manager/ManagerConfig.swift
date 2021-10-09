//
//  ManagerConfig.swift
//  Usiqee
//
//  Created by Guaire94 on 09/10/2021.
//

import Firebase

class ManagerConfig {
    
    // MARK: - Singleton
    static let shared = ManagerConfig()
    private init() {}
    
    // MARK: - Properties
    private lazy var dispatchGroup = DispatchGroup()
    var ads: AdsConfig?
    
    // MARK: - Public
    func synchronise(completion: @escaping () -> Void) {
        dispatchGroup.enter()
        
        ServiceConfig.ads() { adsConfig in
            self.ads = adsConfig
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func clear() {
        ads = nil
    }
}
