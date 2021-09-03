//
//  HelperTracking.swift
//  Usiqee
//
//  Created by Guaire94 on 03/09/2021.
//

import FirebaseAnalytics

class HelperTracking {
    
    static func track(item: Tracking) {
        #if !DEBUG
        let values = item
        Analytics.logEvent(values.name, parameters: values.parameters)
        #endif
    }
}

enum Tracking {
    
    // MARK: - Constants
    private enum Constants {
        enum Alert {
            static let title = "title"
            static let message = "message"
        }
        
        enum AgendaEventDetails {
            static let type = "type"
        }
    }
    
    // MARK: - Alert
    case alertError(title: String, message: String)
    
    // MARK: - News
    case news
    case newsDetails
    case newsDetailsVideo
    case newsDetailsReadOnWebsite
    case newsDetailsOpenAuthorLink

    // MARK: - Tracking consent
    case trackingConsentAuthorized
    case trackingConsentRejected
    
    // MARK: Artist
    case artists
    case artistDetails
    case artistDetailsFollow
    case artistDetailsUnfollow
    case artistDetailsBio
    case artistDetailsNews
    case artistDetailsAgenda
    case artistDetailsOpenBand
    case artistDetailsOpenArtist
    case artistDetailsOpenNews
    case artistDetailsOpenEvent

    // MARK: Agenda
    case agenda
    case agendaPreviousMonth
    case agendaDatePicker
    case agendaFilter
    case agendaNextMonth
    case agendaEventDetails(type: MEventType)
    case agendaEventDetailsAddToCalendar
    case agendaEventDetailsMoreInfos
    case agendaEventDetailsBuyTicket
    
    // MARK: PreAuth
    case preAuthSignUp
    case preAuthSignInWithApple
    case preAuthSignInWithGmail
    case preAuthSignIn
    
    // MARK: SignIn
    case signIn
    case signInDone

    // MARK: SignUp
    case signUp
    case signUpDone
    
    // MARK: Profile
    case profile
    case profileFollowedArtist
    case profileLikedNews
    case profileOpenFollowedArtist
    case profileOpenLikedNews

    // MARK: Settings
    case settings
    case settingsEditProfile
    case settingsNotifications
    case settingsCGU
    case settingsPolicy
    case settingsAbout

    // MARK: - Property
    var values: (name: String, parameters: [String : Any]?) {
        switch self {
        case let .alertError(title, message):
            let parameters: [String: Any] = [
                Constants.Alert.title: title,
                Constants.Alert.message: message
            ]
            return ("AlertError", parameters)
        case .news:
            return ("News", nil)
        case .newsDetails:
            return ("NewsDetails", nil)
        case .newsDetailsVideo:
            return ("NewsDetailsVideo", nil)
        case .newsDetailsReadOnWebsite:
            return ("NewsDetailsReadOnWebsite", nil)
        case .newsDetailsOpenAuthorLink:
            return ("NewsDetailsOpenAuthorLink", nil)
        case .trackingConsentAuthorized:
            return ("TrackingConsentAuthorized", nil)
        case .trackingConsentRejected:
            return ("TrackingConsentRejected", nil)
        case .artists:
            return ("Artists", nil)
        case .artistDetails:
            return ("ArtistDetails", nil)
        case .artistDetailsFollow:
            return ("ArtistDetailsFollow", nil)
        case .artistDetailsUnfollow:
            return ("ArtistDetailsUnfollow", nil)
        case .artistDetailsBio:
            return ("ArtistDetailsBio", nil)
        case .artistDetailsNews:
            return ("ArtistDetailsNews", nil)
        case .artistDetailsAgenda:
            return ("ArtistDetailsAgenda", nil)
        case .artistDetailsOpenBand:
            return ("ArtistDetailsOpenBand", nil)
        case .artistDetailsOpenArtist:
            return ("ArtistDetailsOpenArtist", nil)
        case .artistDetailsOpenNews:
            return ("ArtistDetailsOpenNews", nil)
        case .artistDetailsOpenEvent:
            return ("ArtistDetailsOpenEvent", nil)
        case .agenda:
            return ("Agenda", nil)
        case .agendaPreviousMonth:
            return ("AgendaPreviousMonth", nil)
        case .agendaDatePicker:
            return ("AgendaDatePicker", nil)
        case .agendaFilter:
            return ("AgendaFilter", nil)
        case .agendaNextMonth:
            return ("AgendaNextMonth", nil)
        case .agendaEventDetails(type: let type):
            let parameters: [String: Any] = [
                Constants.AgendaEventDetails.type: type.rawValue
            ]
            return ("AgendaEventDetails", parameters)
        case .agendaEventDetailsAddToCalendar:
            return ("AgendaEventDetailsAddToCalendar", nil)
        case .agendaEventDetailsMoreInfos:
            return ("AgendaEventDetailsMoreInfos", nil)
        case .agendaEventDetailsBuyTicket:
            return ("AgendaEventDetailsBuyTicket", nil)
        case .preAuthSignUp:
            return ("PreAuthSignUp", nil)
        case .preAuthSignInWithApple:
            return ("PreAuthSignInWithApple", nil)
        case .preAuthSignInWithGmail:
            return ("PreAuthSignInWithGmail", nil)
        case .preAuthSignIn:
            return ("PreAuthSignIn", nil)
        case .signIn:
            return ("SignIn", nil)
        case .signInDone:
            return ("SignInDone", nil)
        case .signUp:
            return ("SignUp", nil)
        case .signUpDone:
            return ("SignUpDone", nil)
        case .profile:
            return ("Profile", nil)
        case .profileFollowedArtist:
            return ("ProfileFollowedArtist", nil)
        case .profileLikedNews:
            return ("ProfileLikedNews", nil)
        case .profileOpenFollowedArtist:
            return ("ProfileOpenFollowedArtist", nil)
        case .profileOpenLikedNews:
            return ("ProfileOpenLikedNews", nil)
        case .settings:
            return ("Settings", nil)
        case .settingsEditProfile:
            return ("SettingsEditProfile", nil)
        case .settingsNotifications:
            return ("SettingsNotifications", nil)
        case .settingsCGU:
            return ("SettingsCGU", nil)
        case .settingsPolicy:
            return ("SettingsPolicy", nil)
        case .settingsAbout:
            return ("SettingsAbout", nil)
        }
    }
}
