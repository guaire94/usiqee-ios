//
//  HelperOnBoarding.swift
//  Usiqee
//
//  Created by Guaire94 on 01/10/2021.
//

import Foundation

class HelperOnBoarding {
    static let shared = HelperOnBoarding()
    
    var haveSeenNewsOnBoarding: Bool {
        let haveSeenNewsOnBoarding = UserDefaults.standard.bool(forKey: "haveSeenNewsOnBoarding")
        if !haveSeenNewsOnBoarding {
            UserDefaults.standard.set(true, forKey: "haveSeenNewsOnBoarding")
            return false
        }
        return true
    }
    
    var haveSeenArtistOnBoarding: Bool {
        let haveSeenArtistOnBoarding = UserDefaults.standard.bool(forKey: "haveSeenArtistOnBoarding")
        if !haveSeenArtistOnBoarding {
            UserDefaults.standard.set(true, forKey: "haveSeenArtistOnBoarding")
            return false
        }
        return true
    }
    
    var haveSeenAgendaOnBoarding: Bool {
        let haveSeenAgendaOnBoarding = UserDefaults.standard.bool(forKey: "haveSeenAgendaOnBoarding")
        if !haveSeenAgendaOnBoarding {
            UserDefaults.standard.set(true, forKey: "haveSeenAgendaOnBoarding")
            return false
        }
        return true
    }
}
