//
//  MStoryboard.swift
//  Usiqee
//
//  Created by Quentin Gallois on 22/10/2020.
//

import UIKit

enum MStoryboard: String {
    case AnimateLaunchScreen = "AnimateLaunchScreen"
    case Auth = "Auth"
    case Home = "Home"
    case News = "News"
    case Agenda = "Agenda"
    case Artist = "Artist"
    case Account = "Account"
    case OnBoarding = "OnBoarding"

    var storyboard: UIStoryboard {
        UIStoryboard(name: rawValue, bundle: nil)
    }
}
