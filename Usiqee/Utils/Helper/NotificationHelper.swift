//
//  NotificationManager.swift
//  Mooddy
//
//  Created by Quentin Gallois on 07/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import Foundation
import UserNotifications

struct CurrentNotification {
    var type: Notificat  = .unknow
    var idElem: String          = ""
}

class NotificationManager {
    static let shared = NotificationManager()
    
    var notifications: [SocialNotification] = []
    var currentNotification: CurrentNotification?
    
    var badge = (social: 0, chat: 0) {
        didSet {
            NotificationCenter.default.post(name: .ChatNotification, object: nil)
            NotificationCenter.default.post(name: .SocialNotificationCountChange, object: nil)
            if badge.social == 0 && badge.chat == 0 {
                UIApplication.shared.applicationIconBadgeNumber = 0
            } else {
                UIApplication.shared.applicationIconBadgeNumber = 1
            }
        }
    }

    var offset: Int = 0

    public func clearCurrentNotification() {
        currentNotification = nil
    }
    
    public func clearNotifications() {
        notifications = []
        offset = 0
    }
    
    public func setCurrentNotification(info:[String: Any]) {
        guard let rawType = info["type"] as? String,
            let type:NotificationType = NotificationType(rawValue: rawType) else {
                return
        }
        var currentNotification = CurrentNotification()
        currentNotification.type = type
        switch type {
        case .message:
            guard let chatId:String = info["chat"] as? String else { return }
            currentNotification.idElem = chatId
            break
        case .comment, .like, .identification:
            guard let publicationId:String = info["publication"] as? String else { return }
            currentNotification.idElem = publicationId
            break
        case .follower:
            guard let followerId:String = info["follower"] as? String else { return }
            currentNotification.idElem = followerId
            break
        default:
            break
        }
        self.currentNotification = currentNotification
    }
    
    public func updateDisplay() {
        getNbSocialNotification()
        getNbChatNotification()
    }
    
    public func setCurrentNotification(notification:SocialNotification) {
        var currentNotification = CurrentNotification()
        currentNotification.type = notification.notificationType
        currentNotification.idElem = notification.linked
        self.currentNotification = currentNotification
    }
    
    public func storeNotifications(notifications: [SocialNotification]) {
        let filteredNotifications = notifications.filter{ $0.title != nil }
        self.notifications.append(contentsOf: filteredNotifications)
        offset = self.notifications.count
    }
}

extension NotificationManager {
    
    func getNbChatNotification() {
        guard let coach = ManagerAuth.shared.coach else {
            
            badge.chat = 0
            return
        }
        let query
        let query = usersReference.document(user.id).collection("chats").whereField("unread", isEqualTo: true)
        query.getDocuments { (snap, error) in
            DispatchQueue.main.async {
                if let snap = snap {
                    self.badge.chat = snap.count
                }
            }
        }
    }
}
