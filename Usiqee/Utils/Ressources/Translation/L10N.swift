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
    
    struct signIn {
        static let title: String = NSLocalizedString("SIGNIN_TITLE", comment: "")
        static let noAccount: String = NSLocalizedString("SIGNIN_NOACCOUNT", comment: "")
        struct form {
            static let valid: String = NSLocalizedString("SIGNIN_FORM_VALID", comment: "")
        }
    }

    struct signUp {
        static let title: String = NSLocalizedString("SIGNUP_TITLE", comment: "")
        struct form {
            static let valid: String = NSLocalizedString("SIGNUP_FORM_VALID", comment: "")
        }
    }

    struct Artist {
        static let searchPlaceholder: String = NSLocalizedString("ARTIST_SEARCH_PLACEHOLDER", comment: "")
        struct allArtist {
            static let title: String = NSLocalizedString("ARTIST_ALL_TITLE", comment: "")
            static let emptyListMessage: String = NSLocalizedString("ARTIST_ALL_EMPTY_LIST", comment: "")
        }
    }
    
    struct ArtistDetails {
        static let label: String = NSLocalizedString("ARTIST_DETAILS_LABEL", comment: "")
        static let major: String = NSLocalizedString("ARTIST_DETAILS_MAJOR", comment: "")
        static let group: String = NSLocalizedString("ARTIST_DETAILS_GROUP", comment: "")
        static let activity: String = NSLocalizedString("ARTIST_DETAILS_ACTIVITY", comment: "")
        static func activityContent(from year: String) -> String  {
            String(format: NSLocalizedString("ARTIST_DETAILS_ACTIVITY_CONTENT", comment: ""), year)
        }
        static func followed(number: String) -> String  {
            String(format: NSLocalizedString("ARTIST_DETAILS_FOLLOWED", comment: ""), number)
        }
        
        struct Menu {
            static let news: String = NSLocalizedString("ARTIST_DETAILS_MENU_NEWS", comment: "")
            static let calendar: String = NSLocalizedString("ARTIST_DETAILS_MENU_CALENDAR", comment: "")
            static let discography: String = NSLocalizedString("ARTIST_DETAILS_MENU_DISCOGRAPHY", comment: "")
        }
    }

    struct version {
        static let new: String = NSLocalizedString("VERSION_NEW", comment: "")
        static let available: String = NSLocalizedString("VERSION_AVAILABLE", comment: "")
        static let redirectAppStore: String = NSLocalizedString("VERSION_REDIRECT_APPSTORE", comment: "")
        static let updateLater: String = NSLocalizedString("VERSION_UPDATE_LATER", comment: "")
    }
}
