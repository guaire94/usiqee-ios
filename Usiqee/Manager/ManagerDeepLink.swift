//
//  ManagerDeepLink.swift
//  Usiqee
//
//  Created by Amine on 08/06/2021.
//

import Foundation

enum DeepLinkType {
    case eventDetails(eventId: String)
    case newsDetails(newsId: String)
    case storeFeedback
}

class ManagerDeepLink {
    
    // MARK: - Constants
    private enum Constants {
        enum id {
            static let event = "eventId"
            static let news = "newsId"
        }
        
        enum host {
            static let eventDetails = "eventDetails"
            static let newsDetails = "newsDetails"
            static let storeFeedback = "storeFeedback"
        }
        
        enum notification {
            static let deeplink = "deeplink"
        }
    }
    
    // MARK: - Singleton
    static let shared = ManagerDeepLink()
    private init() {}
    
    // MARK: - Properties
    private(set) var currentDeepLink : DeepLinkType?
    
    // MARK: - Public
    func clear() {
        currentDeepLink = nil
    }
    
    func setDeeplinkFromDeepLink(url: URL) {
        parseDeeplink(url: url)
    }
    
    func setDeeplinkFromNotification(info: [String: Any]) {
        guard let deepLink = info[Constants.notification.deeplink] as? String,
           let url = URL(string: deepLink) else {
            return
        }
        
        parseDeeplink(url: url)
    }
    
    // MARK: - Private
    private func parseDeeplink(url: URL) {
        guard let host = url.host else { return }
        
        var parameters: [String: String] = [:]
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }
        
        currentDeepLink = nil
        switch host {
        case Constants.host.eventDetails:
            guard let eventId = parameters[Constants.id.event] else { return }
            
            currentDeepLink = .eventDetails(eventId: eventId)
        case Constants.host.newsDetails:
            guard let newsId = parameters[Constants.id.news] else { return }
            
            currentDeepLink = .newsDetails(newsId: newsId)
        case Constants.host.storeFeedback:
            currentDeepLink = .storeFeedback
        default:
            currentDeepLink = nil
        }
    }
}
