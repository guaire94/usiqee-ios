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
        let values = item.values
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
    
    // MARK: - Tracking consent
    case trackingConsentAuthorized
    case trackingConsentRejected
    
    // MARK: - News
    case news
    case newsDetails
    case newsDetailsVideo
    case newsDetailsReadOnWebsite
    case newsDetailsOpenAuthorSocialMedia
    case newsDetailsShare
    case newsDetailsLike
    case newsDetailsUnlike
    case newsDetailsOpenArtist
    case newsDetailsOpenBand

    // MARK: Artist & Band
    case artistsAndBands
    
    case artistDetails
    case artistDetailsFollow
    case artistDetailsUnfollow
    case artistDetailsBio
    case artistDetailsNews
    case artistDetailsAgenda
    case artistDetailsOpenBand
    case artistDetailsOpenNews
    case artistDetailsOpenEvent
    
    case bandDetails
    case bandDetailsFollow
    case bandDetailsUnfollow
    case bandDetailsBio
    case bandDetailsNews
    case bandDetailsAgenda
    case bandDetailsOpenArtist
    case bandDetailsOpenNews
    case bandDetailsOpenEvent

    // MARK: Agenda
    case agenda
    case agendaPreviousMonth
    case agendaDatePicker
    case agendaFilter
    case agendaNextMonth
    case agendaEventDetails(type: MEventType)
    case agendaEventDetailsAddToCalendar
    case agendaEventDetailsMoreInfos
    case agendaEventDetailsOpenArtist
    case agendaEventDetailsOpenBand

    // MARK: PreAuth
    case preAuth
    case preAuthSignInWithApple
    case preAuthSignInWithGmail
    
    // MARK: SignIn
    case signIn
    case signInDone

    // MARK: SignUp
    case signUp
    case signUpDone
    
    // MARK: ForgetPassword
    case forgetPassword
    case forgetPasswordDone

    // MARK: Profile
    case profile
    case profileFollowedArtist
    case profileLikedNews
    case profileOpenLikedNews
    case profileFollowedArtistUnfollowBand
    case profileFollowedArtistUnfollowArtist

    // MARK: Settings
    case settings
    case settingsEditProfile
    case settingsNotifications
    case settingsTermsAndConditions
    case settingsPolicy
    case settingsLogout
    
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
        case .newsDetailsOpenAuthorSocialMedia:
            return ("NewsDetailsOpenAuthorSocialMedia", nil)
        case .newsDetailsShare:
            return ("NewsDetailsShare", nil)
        case .newsDetailsLike:
            return ("NewsDetailsLike", nil)
        case .newsDetailsUnlike:
            return ("NewsDetailsUnlike", nil)
        case .newsDetailsOpenArtist:
            return ("NewsDetailsOpenArtist", nil)
        case .newsDetailsOpenBand:
            return ("NewsDetailsOpenBand", nil)
        case .trackingConsentAuthorized:
            return ("TrackingConsentAuthorized", nil)
        case .trackingConsentRejected:
            return ("TrackingConsentRejected", nil)
        case .artistsAndBands:
            return ("ArtistsAndBands", nil)
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
        case .artistDetailsOpenNews:
            return ("ArtistDetailsOpenNews", nil)
        case .artistDetailsOpenEvent:
            return ("ArtistDetailsOpenEvent", nil)
        case .bandDetails:
            return ("BandDetails", nil)
        case .bandDetailsFollow:
            return ("BandDetailsFollow", nil)
        case .bandDetailsUnfollow:
            return ("BandDetailsUnfollow", nil)
        case .bandDetailsBio:
            return ("BandDetailsBio", nil)
        case .bandDetailsNews:
            return ("BandDetailsNews", nil)
        case .bandDetailsAgenda:
            return ("BandDetailsAgenda", nil)
        case .bandDetailsOpenArtist:
            return ("BandDetailsOpenArtist", nil)
        case .bandDetailsOpenNews:
            return ("BandDetailsOpenNews", nil)
        case .bandDetailsOpenEvent:
            return ("BandDetailsOpenEvent", nil)
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
        case .agendaEventDetailsOpenArtist:
            return ("AgendaEventDetailsOpenArtist", nil)
        case .agendaEventDetailsOpenBand:
            return ("AgendaEventDetailsOpenBand", nil)
        case .preAuth:
            return ("PreAuth", nil)
        case .preAuthSignInWithApple:
            return ("PreAuthSignInWithApple", nil)
        case .preAuthSignInWithGmail:
            return ("PreAuthSignInWithGmail", nil)
        case .signIn:
            return ("SignIn", nil)
        case .signInDone:
            return ("SignInDone", nil)
        case .signUp:
            return ("SignUp", nil)
        case .signUpDone:
            return ("SignUpDone", nil)
        case .forgetPassword:
            return ("ForgetPassword", nil)
        case .forgetPasswordDone:
            return ("ForgetPasswordDone", nil)
        case .profile:
            return ("Profile", nil)
        case .profileFollowedArtist:
            return ("ProfileFollowedArtist", nil)
        case .profileLikedNews:
            return ("ProfileLikedNews", nil)
        case .profileOpenLikedNews:
            return ("ProfileOpenLikedNews", nil)
        case .profileFollowedArtistUnfollowArtist:
            return ("ProfileFollowedArtistUnfollowArtist", nil)
        case .profileFollowedArtistUnfollowBand:
            return ("ProfileFollowedArtistUnfollowBand", nil)
        case .settings:
            return ("Settings", nil)
        case .settingsEditProfile:
            return ("SettingsEditProfile", nil)
        case .settingsNotifications:
            return ("SettingsNotifications", nil)
        case .settingsTermsAndConditions:
            return ("SettingsTermsAndConditions", nil)
        case .settingsPolicy:
            return ("SettingsPolicy", nil)
        case .settingsLogout:
            return ("SettingsLogout", nil)
        }
    }
}
