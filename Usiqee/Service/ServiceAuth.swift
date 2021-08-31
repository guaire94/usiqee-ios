//
//  ServiceUser.swift
//  Usiqee
//
//  Created by Quentin Gallois on 21/10/2020.
//

import Firebase

class ServiceAuth {

    static func signUp(mail: String, avatar: String, username: String) {
        guard let user = Auth.auth().currentUser else { return }
        let data: [String : Any] = [
            "avatar": avatar,
            "mail": mail,
            "username": username,
            "createdDate" : Timestamp()
        ]
        FFirestoreReference.user.document(user.uid).setData(data, merge: true)
    }
    
    static func getProfile(completion: @escaping (User?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        FFirestoreReference.user.document(user.uid).getDocument { (document, error) in
            guard let document = document, document.exists,
                  let user = try? document.data(as: User.self) else {
                completion(nil)
                return
            }
            completion(user)
        }
    }
    
    static func updateProfile(username: String, avatar: String) {
        guard let user = Auth.auth().currentUser else { return }
        let data: [String : Any] = [
            "avatar": avatar,
            "username": username
        ]
        FFirestoreReference.user.document(user.uid).setData(data, merge: true)
    }
}
