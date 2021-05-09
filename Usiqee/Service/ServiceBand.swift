//
//  ServiceBand.swift
//  Usiqee
//
//  Created by Amine on 07/04/2021.
//

import FirebaseFirestore

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
        self.listener = FFirestoreReference.band.addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            snapshot.documentChanges.forEach { diff in
                guard let band = try? diff.document.data(as: Band.self) else { return }
                
                switch diff.type {
                case .added:
                    delegate.dataAdded(band: band)
                case .modified:
                    delegate.dataModified(band: band)
                case .removed:
                    delegate.dataRemoved(band: band)
                }
            }
        }
    }
}
