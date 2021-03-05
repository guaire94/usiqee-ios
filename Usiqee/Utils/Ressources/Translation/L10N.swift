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
    
    struct affiliateToClub {
        static let title: String = NSLocalizedString("AFFILIATE_TO_CLUB_TITLE", comment: "")
        static let subTitle: String = NSLocalizedString("AFFILIATE_TO_CLUB_SUBTITLE", comment: "")
        struct form {
            static let affiliationCode: String = NSLocalizedString("AFFILIATE_TO_CLUB_FORM_AFFILIATION_CODE", comment: "")
            static let sport: String = NSLocalizedString("AFFILIATE_TO_CLUB_FORM_SPORT", comment: "")
            static let category: String = NSLocalizedString("AFFILIATE_TO_CLUB_FORM_CATEGORY", comment: "")
            static let subCategory: String = NSLocalizedString("AFFILIATE_TO_CLUB_FORM_SUBCATEGORY", comment: "")
            static let valid: String = NSLocalizedString("AFFILIATE_TO_CLUB_FORM_VALID", comment: "")
            
            struct error {
               static let affiliationCode: String = NSLocalizedString("AFFILIATE_TO_CLUB_FORM_ERROR_AFFILIATION_CODE", comment: "")
           }
        }
    }
    
    struct affiliateToClubSuccess {
        static let title: String = NSLocalizedString("AFFILIATE_TO_CLUB_SUCCESS_TITLE", comment: "")
        static let subTitle: String = NSLocalizedString("AFFILIATE_TO_CLUB_SUCCESS_SUBTITLE", comment: "")
        static let activeNotifications: String = NSLocalizedString("AFFILIATE_TO_CLUB_SUCCESS_ACTIVE_NOTIFICATIONS", comment: "")
    }
    
    struct account {
        static let sportDescription: String = NSLocalizedString("ACCOUNT_SPORT_DESCRIPTION", comment: "")
        static let myInformations: String = NSLocalizedString("ACCOUNT_MY_INFORMATIONS", comment: "")
        static let myEvents: String = NSLocalizedString("ACCOUNT_MY_EVENTS", comment: "")
    }
    
    struct map {
        struct filter {
            static let title: String = NSLocalizedString("MAP_FILTER_TITLE", comment: "")
            static let startDate: String = NSLocalizedString("MAP_FILTER_START_DATE", comment: "")
            static let endDate: String = NSLocalizedString("MAP_FILTER_END_DATE", comment: "")
        }
    }
    
    struct event {
        struct type {
            static let friendly: String = NSLocalizedString("EVENT_TYPE_FRIENDLY", comment: "")
            static let tournament: String = NSLocalizedString("EVENT_TYPE_TOURNAMENT", comment: "")
            static let plateau: String = NSLocalizedString("EVENT_TYPE_PLATEAU", comment: "")
        }
        struct informations {
            static let nbTeams: String = NSLocalizedString("EVENT_INFORMATIONS_NB_TEAMS", comment: "")
        }
        
        struct participant {
            static let owner: String = NSLocalizedString("EVENT_PARTICIPANT_OWNER", comment: "")
            static let participant: String = NSLocalizedString("EVENT_PARTICIPANT_PARTICIPANT", comment: "")
            
            struct action {
                static let refused: String = NSLocalizedString("EVENT_PARTICIPANT_ACTION_REFUSED", comment: "")
                static let validate: String = NSLocalizedString("EVENT_PARTICIPANT_ACTION_VALIDATE", comment: "")
                static let cancel: String = NSLocalizedString("EVENT_PARTICIPANT_ACTION_CANCEL", comment: "")
                static let participation: String = NSLocalizedString("EVENT_PARTICIPANT_ACTION_PARTICIPATION", comment: "")
            }
        }
        static let participate: String = NSLocalizedString("EVENT_PARTICIPATE", comment: "")
        
        struct create {
            static let title: String = NSLocalizedString("EVENT_CREATE_TITLE", comment: "")
            struct form {
                static let name: String = NSLocalizedString("EVENT_CREATE_FORM_NAME", comment: "")
                static let desc: String = NSLocalizedString("EVENT_CREATE_FORM_DESC", comment: "")
                static let type: String = NSLocalizedString("EVENT_CREATE_FORM_TYPE", comment: "")
                static let nbTeams: String = NSLocalizedString("EVENT_CREATE_FORM_NBTEAMS", comment: "")
                static let dateAndHour: String = NSLocalizedString("EVENT_CREATE_FORM_DATE_AND_HOUR", comment: "")
                static let address: String = NSLocalizedString("EVENT_CREATE_FORM_ADDRESS", comment: "")
                static let valid: String = NSLocalizedString("EVENT_CREATE_FORM_VALID", comment: "")
                
                struct error {
                   static let unfill: String = NSLocalizedString("EVENT_CREATE_FORM_ERROR_UNFILL", comment: "")
               }
            }
        }
        
        struct modify {
            static let title: String = NSLocalizedString("EVENT_MODIFY_TITLE", comment: "")
            struct form {
                static let name: String = NSLocalizedString("EVENT_CREATE_FORM_NAME", comment: "")
                static let desc: String = NSLocalizedString("EVENT_CREATE_FORM_DESC", comment: "")
                static let type: String = NSLocalizedString("EVENT_CREATE_FORM_TYPE", comment: "")
                static let nbTeams: String = NSLocalizedString("EVENT_CREATE_FORM_NBTEAMS", comment: "")
                static let dateAndHour: String = NSLocalizedString("EVENT_CREATE_FORM_DATE_AND_HOUR", comment: "")
                static let address: String = NSLocalizedString("EVENT_CREATE_FORM_ADDRESS", comment: "")
                static let valid: String = NSLocalizedString("EVENT_MODIFY_FORM_VALID", comment: "")
                static let cancel: String = NSLocalizedString("EVENT_MODIFY_FORM_CANCEL", comment: "")

                struct error {
                   static let unfill: String = NSLocalizedString("EVENT_CREATE_FORM_ERROR_UNFILL", comment: "")
               }
            }
        }
    }
    
    struct chat {
        static let title: String = NSLocalizedString("CHAT_TITLE", comment: "")
        static let placeholder: String = NSLocalizedString("CHAT_PLACEHOLDER", comment: "")
        static let picture: String = NSLocalizedString("CHAT_PICTURE", comment: "")
    }
    
    struct addressSearch {
        static let placeholder: String = NSLocalizedString("ADDRESSSEARCH_SEARCHPLACEHOLDER", comment: "")
    }

    struct version {
        static let new: String = NSLocalizedString("VERSION_NEW", comment: "")
        static let available: String = NSLocalizedString("VERSION_AVAILABLE", comment: "")
        static let redirectAppStore: String = NSLocalizedString("VERSION_REDIRECT_APPSTORE", comment: "")
        static let updateLater: String = NSLocalizedString("VERSION_UPDATE_LATER", comment: "")
    }
}
