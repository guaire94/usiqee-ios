//
//  Notification.swift
//  Mooddy
//
//  Created by Quentin Gallois on 5/19/19.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import Foundation

struct SocialNotification: Codable {
    var id: String
    var state: String
    var count: Int

    var linked: String
    var type:String
    var data:DataNotification

    var createdAt:String
    var updatedAt:String
        
    var notificationType:NotificationType {
        guard let type = NotificationType(rawValue: self.type) else {
            return .unknow
        }
        return type
    }
    
    var notificationState:NotificationState {
        guard let state = NotificationState(rawValue: self.state) else {
            return .readed
        }
        return state
    }
    
    var avatar: String? {
        guard let user = data.user else { return nil }
        return user.avatar
    }
    
    var cover: String? {
        guard let track = data.track else { return nil }
        return track.cover
    }
    
    var title: String? {
        switch notificationType {
        case .follower:
            guard let user = data.user else { return nil }
            return String(format: L10N.notification.follower.title, arguments: [user.fullname])
        case .like:
            guard let track = data.track, let user = data.user else { return nil }
            return String(format: L10N.notification.like.title, arguments: [user.fullname, track.title])
        case .comment:
            guard let publication = data.publication, let track = publication.track else { return nil }
            var fullname = ""
            if let user = data.user {
                fullname = user.fullname
            } else if let userWhoCommented = data.userWhoCommented {
                fullname = userWhoCommented
            }
            return String(format: L10N.notification.comment.title, arguments: [fullname, track.title])
        case .identification:
            guard let user = data.user else { return nil }
            return String(format: L10N.notification.identification.title, arguments: [user.fullname])
        default:
            return nil
        }
    }
}

struct DataNotification: Codable {
    var user:UserDataNotification?
    var track:TrackDataNotification?
    var publication:PublicationDataNotification?
    var userWhoCommented: String?
    var sender:String?
}

struct UserDataNotification: Codable {
    var id: String
    var firstname: String
    var lastname: String?
    var avatar: String?
    
    var fullname: String {
        var fullname = firstname
        if let lastname = lastname {
            fullname += " " + lastname
        }
        return fullname
    }
}

struct PublicationDataNotification: Codable {
    var id: String
    var track:TrackDataNotification?
}

struct TrackDataNotification: Codable {
    var id: String
    var title: String
    var artist: String
    var album: String
    var cover: String
    var type: String
    var uid: String    
}
