//
//  FIRUser+M.swift
//  Usiqee
//
//  Created by Amine on 10/06/2021.
//

import Firebase

extension Firebase.User {
    
    var toFollower: Follower? {
        guard let user = ManagerAuth.shared.user else {
            return nil
        }
        return Follower(userId: uid, username: user.username, avatar: user.avatar)
    }
}

