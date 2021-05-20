//
//  L10N.swift
//  Usiqee
//
//  Created by Quentin Gallois on 20/10/2020.
//

import Foundation

struct L10N {

    struct global {
        struct action {
            static let confirm: String = NSLocalizedString("GLOBAL_ACTIONS_CONFIRM", comment: "")
            static let ok: String = NSLocalizedString("GLOBAL_ACTIONS_OK", comment: "")
            static let cancel: String = NSLocalizedString("GLOBAL_ACTIONS_CANCEL", comment: "")
            static let maybeLater: String = NSLocalizedString("GLOBAL_ACTIONS_MAYBE_LATER", comment: "")
            static let delete: String = NSLocalizedString("GLOBAL_ACTIONS_DELETE", comment: "")
        }
        struct date {
           static let timeAgo: String = NSLocalizedString("GLOBAL_DATE_TIMEAGO", comment: "")
       }
    }

    struct user {
        struct form {
            static let mail: String = NSLocalizedString("USER_FORM_MAIL", comment: "")
            static let password: String = NSLocalizedString("USER_FORM_PASSWORD", comment: "")
            static let username: String = NSLocalizedString("USER_FORM_FIRSTNAME", comment: "")
            static let lastName: String = NSLocalizedString("USER_FORM_LASTNAME", comment: "")

            struct error {
               static let mail: String = NSLocalizedString("USER_FORM_ERROR_MAIL", comment: "")
               static let password: String = NSLocalizedString("USER_FORM_ERROR_PASSWORD", comment: "")
           }
        }
    }
    
    struct preAuth {
        static let signIn: String = NSLocalizedString("PRE_AUTH_SIGNIN", comment: "")
        static let signUp: String = NSLocalizedString("PRE_AUTH_SIGNUP", comment: "")
        static let separator: String = NSLocalizedString("PRE_AUTH_OR", comment: "")
    }
    
    struct AccountNotLogged {
        static let title: String = NSLocalizedString("ACCOUNT_NOT_LOGGED_TITLE", comment: "")
        static let subtitle: String = NSLocalizedString("ACCOUNT_NOT_LOGGED_SUBTITLE", comment: "")
        static let `continue`: String = NSLocalizedString("ACCOUNT_NOT_LOGGED_CONTINUE", comment: "")
        static let follow: String = NSLocalizedString("ACCOUNT_NOT_LOGGED_FOLLOW", comment: "")
        static let comments: String = NSLocalizedString("ACCOUNT_NOT_LOGGED_COMMENTS", comment: "")
        static let likes: String = NSLocalizedString("ACCOUNT_NOT_LOGGED_LIKES", comment: "")
        static let notifications: String = NSLocalizedString("ACCOUNT_NOT_LOGGED_NOTIFICATIONS", comment: "")
        static let trophies: String = NSLocalizedString("ACCOUNT_NOT_LOGGED_TROPHIES", comment: "")
        static let events: String = NSLocalizedString("ACCOUNT_NOT_LOGGED_EVENTS", comment: "")
    }
    
    struct signIn {
        static let title: String = NSLocalizedString("SIGNIN_TITLE", comment: "")
        static let noAccount: String = NSLocalizedString("SIGNIN_NOACCOUNT", comment: "")
        struct form {
            static let valid: String = NSLocalizedString("SIGNIN_FORM_VALID", comment: "")
            static let forgetPassword: String = NSLocalizedString("SIGNIN_FORM_FORGET_PASSWORD", comment: "")
        }
    }

    struct signUp {
        static let title: String = NSLocalizedString("SIGNUP_TITLE", comment: "")
        struct form {
            static let valid: String = NSLocalizedString("SIGNUP_FORM_VALID", comment: "")
            static let notEmptyError: String = NSLocalizedString("SIGNUP_FORM_NOT_EMPTY_ERROR", comment: "")
        }
    }
    
    struct ForgetPassword {
        static let title: String = NSLocalizedString("FORGET_PASSWORD_TITLE", comment: "")
        struct form {
            static let valid: String = NSLocalizedString("FORGET_PASSWORD_FORM_VALID", comment: "")
        }
    }

    struct Artist {
        static let searchPlaceholder: String = NSLocalizedString("ARTIST_SEARCH_PLACEHOLDER", comment: "")
        struct allArtist {
            static let title: String = NSLocalizedString("ARTIST_ALL_TITLE", comment: "")
            static let emptyListMessage: String = NSLocalizedString("ARTIST_ALL_EMPTY_LIST", comment: "")
        }
        struct FollowedArtist {
            static let title: String = NSLocalizedString("ARTIST_FOLLOWED_TITLE", comment: "")
            static let emptyListMessage: String = NSLocalizedString("ARTIST_FOLLOWED_EMPTY_LIST", comment: "")
        }
    }
    
    struct ArtistDetails {
        static let title: String = NSLocalizedString("ARTIST_DETAILS_TITLE", comment: "")
        static let activity: String = NSLocalizedString("ARTIST_DETAILS_ACTIVITY", comment: "")
        static let followed: String = NSLocalizedString("ARTIST_DETAILS_FOLLOWED", comment: "")
        static let follow: String = NSLocalizedString("ARTIST_DETAILS_FOLLOW", comment: "")
        static let unfollow: String = NSLocalizedString("ARTIST_DETAILS_UNFOLLOW", comment: "")
        
        struct Menu {
            static let news: String = NSLocalizedString("ARTIST_DETAILS_MENU_NEWS", comment: "")
            static let calendar: String = NSLocalizedString("ARTIST_DETAILS_MENU_CALENDAR", comment: "")
            static let bio: String = NSLocalizedString("ARTIST_DETAILS_MENU_BIO", comment: "")
        }
        
        struct Discography {
            static let title: String = NSLocalizedString("ARTIST_DETAILS_DISCOGRAPHY_TITLE", comment: "")
            static let subtitle: String = NSLocalizedString("ARTIST_DETAILS_DISCOGRAPHY_SUBTITLE", comment: "")
        }
    }

    struct UserDetails {
        struct Menu {
            static func followed(_ numberOfFollower: Int) -> String {
                String(format: NSLocalizedString("USER_DETAILS_MENU_FOLLOWED", comment: ""), numberOfFollower)
            }
            static func favoris(_ numberOfFavoris: Int) -> String {
                String(format: NSLocalizedString("USER_DETAILS_MENU_FAVORIS", comment: ""), numberOfFavoris)
            }
        }
        static let unfollow: String = NSLocalizedString("USER_DETAILS_UNFOLLOW", comment: "")
        static let followedEmptyListMessage = NSLocalizedString("USER_DETAILS_FOLLOWED_EMPTY_LIST", comment: "")
    }
    
    struct AccountSettings {
        static let title: String = NSLocalizedString("ACCOUNT_SETTINGS_TITLE", comment: "")
        static let logout: String = NSLocalizedString("ACCOUNT_SETTINGS_LOGOUT", comment: "")
        static let legalNotice: String = NSLocalizedString("ACCOUNT_SETTINGS_LEGAL_NOTICE", comment: "")
        static let privacy: String = NSLocalizedString("ACCOUNT_SETTINGS_PRIVACY", comment: "")
        static let cgu: String = NSLocalizedString("ACCOUNT_SETTINGS_CGU", comment: "")
        static let notifications: String = NSLocalizedString("ACCOUNT_SETTINGS_NOTIFICATIONS", comment: "")
        static let manageNotifications: String = NSLocalizedString("ACCOUNT_SETTINGS_MANAGE_NOTIFICATIONS", comment: "")
    }
    
    struct version {
        static let new: String = NSLocalizedString("VERSION_NEW", comment: "")
        static let available: String = NSLocalizedString("VERSION_AVAILABLE", comment: "")
        static let redirectAppStore: String = NSLocalizedString("VERSION_REDIRECT_APPSTORE", comment: "")
        static let updateLater: String = NSLocalizedString("VERSION_UPDATE_LATER", comment: "")
    }
    
    struct ImagePicker {
       static let LoadFromGallery: String = NSLocalizedString("IMAGE_PICKER_GALLERY", comment: "")
        static let takeAPhoto: String = NSLocalizedString("IMAGE_PICKER_TAKE_A_PHOTO", comment: "")
   }
}
