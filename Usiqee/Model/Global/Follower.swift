//
//  Follower.swift
//  Usiqee
//
//  Created by Quentin Gallois on 22/10/2020.
//

struct Follower: Codable {
    var userId: String
    var username: String
    var avatar: String
    
    var toRelated: [String : Any] {
        [
            "userId": userId,
            "username": username,
            "avatar": avatar
        ]
    }
}
