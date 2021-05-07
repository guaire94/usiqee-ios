//
//  ServiceDeviceToken.swift
//  Usiqee
//
//  Created by Amine on 06/05/2021.
//

import Foundation
import Firebase

class ServiceDeviceToken {
    static let shared = ServiceDeviceToken()
    
    func register() {
        guard let userId = ManagerAuth.shared.user?.id, let token = Messaging.messaging().fcmToken else { return }
        FFirestoreReference.user.document(userId).updateData(["devices": FieldValue.arrayUnion([token])])
    }
    
    func unregister(token:String) {
        guard let userId = ManagerAuth.shared.user?.id else { return }
        FFirestoreReference.user.document(userId).updateData(["devices": FieldValue.arrayRemove([token])])
    }
}
