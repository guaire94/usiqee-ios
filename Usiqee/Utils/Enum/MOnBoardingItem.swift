//
//  MOnBoarding.swift
//  Usiqee
//
//  Created by Guaire94 on 28/09/2021.
//

enum MOnBoardingItem {
    case News
    case Agenda
    case Artist
    
    var viewModels: [(title: String, description: String)] {
        switch self {
        case .News:
            return [
                (title: L10N.OnBoarding.News.PageOne.title, description: L10N.OnBoarding.News.PageOne.description),
                (title: L10N.OnBoarding.News.PageTwo.title, description: L10N.OnBoarding.News.PageTwo.description),
            ]
        case .Agenda:
            return [
                (title: L10N.OnBoarding.Agenda.PageOne.title, description: L10N.OnBoarding.Agenda.PageOne.description),
                (title: L10N.OnBoarding.Agenda.PageTwo.title, description: L10N.OnBoarding.Agenda.PageTwo.description),
            ]
        case .Artist:
            return [
                (title: L10N.OnBoarding.Aritst.PageOne.title, description: L10N.OnBoarding.Aritst.PageOne.description),
                (title: L10N.OnBoarding.Aritst.PageTwo.title, description: L10N.OnBoarding.Aritst.PageTwo.description),
                (title: L10N.OnBoarding.Aritst.PageThree.title, description: L10N.OnBoarding.Aritst.PageThree.description),
            ]
        }
    }
}
