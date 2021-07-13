//
//  Config.swift
//  Usiqee
//
//  Created by Quentin Gallois on 21/10/2020.
//


enum Config {
    static let AppStoreLink = "itms-apps://itunes.apple.com/app/id1561023361"
    
    #if DEBUG
        static let WormholyIsEnabled = true
    #else
        static let WormholyIsEnabled = false
    #endif
    
    #if DEBUG
        static let adUnitId: String = "ca-app-pub-3940256099942544/3986624511"
    #else
        static let adUnitId: String = "ca-app-pub-3940256099942544/3986624511"
    #endif
}
