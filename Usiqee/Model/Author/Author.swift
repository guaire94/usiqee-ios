//
//  Author.swift
//  Usiqee
//
//  Created by Guaire94 on 04/03/2021.
//

import FirebaseFirestoreSwift

struct Author: Identifiable, Codable {
    
    // MARK: - Enum
    enum SocialMedia: Int {
        case twitter = 1
        case facebook
        case instagram
        case youtube
        case snapchat
        case twitch
        case tiktok
        case linkedin
        case web
        
        var image: UIImage? {
            switch self {
            case .twitter:
                return #imageLiteral(resourceName: "twitter")
            case .facebook:
                return #imageLiteral(resourceName: "facebook")
            case .instagram:
                return #imageLiteral(resourceName: "instagram")
            case .youtube:
                return #imageLiteral(resourceName: "youtube")
            case .snapchat:
                return #imageLiteral(resourceName: "snapchat")
            case .twitch:
                return #imageLiteral(resourceName: "twitch")
            case .tiktok:
                return #imageLiteral(resourceName: "tiktok")
            case .linkedin:
                return #imageLiteral(resourceName: "linkedin")
            case .web:
                return #imageLiteral(resourceName: "web")
            }
        }
    }
    
    // MARK: - Properties
    @DocumentID var id: String?
    let name: String
    let avatar: String
    let desc: String
    let twitterLink: String?
    let fbLink: String?
    let instagramLink: String?
    let youtubeLink: String?
    let snapchatLink: String?
    let twitchLink: String?
    let tiktokLink: String?
    let linkedinLink: String?
    let webLink: String?
    
    // MARK: - Helper
    var hasExternalLinks: Bool {
        !externalLinks.isEmpty
    }
    
    var externalLinks: [SocialMedia] {
        var result: [SocialMedia] = []
        
        if twitterLink != nil {
            result.append(.twitter)
        }
        
        if fbLink != nil {
            result.append(.facebook)
        }
        
        if instagramLink != nil {
            result.append(.instagram)
        }
        
        if youtubeLink != nil {
            result.append(.youtube)
        }
        
        if snapchatLink != nil {
            result.append(.snapchat)
        }
        
        if twitchLink != nil {
            result.append(.twitch)
        }
        
        if tiktokLink != nil {
            result.append(.tiktok)
        }
        
        if linkedinLink != nil {
            result.append(.linkedin)
        }
        
        if webLink != nil {
            result.append(.web)
        }
        
        return result
    }
    
    func externalLink(for socialMedia: SocialMedia) -> String? {
        switch socialMedia {
        case .twitter:
            return twitterLink
        case .facebook:
            return fbLink
        case .instagram:
            return instagramLink
        case .youtube:
            return youtubeLink
        case .snapchat:
            return snapchatLink
        case .twitch:
            return twitchLink
        case .tiktok:
            return tiktokLink
        case .linkedin:
            return linkedinLink
        case .web:
            return webLink
        }
    }
}
