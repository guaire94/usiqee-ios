//
//  ServiceBand.swift
//  Usiqee
//
//  Created by Amine on 07/04/2021.
//

import FirebaseFirestore
import Firebase

protocol ServiceBandDelegate {
    func dataAdded(band: Band)
    func dataModified(band: Band)
    func dataRemoved(band: Band)
}

class ServiceBand {
    
    // MARK: - Property
    private static var listener: ListenerRegistration?
    
    // MARK: - GET
    static func listenBands(delegate: ServiceBandDelegate) {
        listener?.remove()
        ManagerMusicalEntity.shared.clearBands()
        self.listener = FFirestoreReference.band.addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let band = try? diff.document.data(as: Band.self) else { return }
                
                switch diff.type {
                case .added:
                    delegate.dataAdded(band: band)
                    ManagerMusicalEntity.shared.add(band: band)
                case .modified:
                    delegate.dataModified(band: band)
                    ManagerMusicalEntity.shared.update(band: band)
                case .removed:
                    delegate.dataRemoved(band: band)
                    ManagerMusicalEntity.shared.delete(band: band)
                }
            }
        }
    }
    
    static func follow(band: Band, completion: @escaping (Error?) -> Void)  {
        guard let currentUser = ManagerAuth.shared.user,
              let userId = currentUser.id else {
            return
        }
        let data: [String : Any] = [
            "bandId": band.id,
            "name": band.name,
            "avatar": band.avatar
        ]
        FFirestoreReference.userFollowedBands(userId: userId).addDocument(data: data) { error in
            if let error = error {
                completion(error)
                return
            }
            
            ManagerAuth.shared.synchronise {
                completion(nil)
            }
        }
    }
    
    static func unfollow(band: RelatedBand, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser,
              let bandId = band.id else {
            return
        }
        
        FFirestoreReference.userFollowedBands(userId: user.uid).document(bandId).delete { error in
            if let error = error {
                completion(error)
                return
            }
            
            ManagerAuth.shared.synchronise {
                completion(nil)
            }
        }
    }
}
