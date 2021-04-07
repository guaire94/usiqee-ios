//
//  Config.swift
//  Usiqee
//
//  Created by Quentin Gallois on 21/10/2020.
//


enum Config {
    static var AppStoreLink = "itms-apps://itunes.apple.com/app/id1561023361"
    
    #if DEBUG
        static var WormholyIsEnabled = true
    #else
        static var WormholyIsEnabled = false
    #endif
}
