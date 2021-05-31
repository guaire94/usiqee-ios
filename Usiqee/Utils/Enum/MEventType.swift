//
//  MEventType.swift
//  Usiqee
//
//  Created by P995987 on 20/11/2020.
//

enum MEventType: String, CaseIterable {
    case ep
    case album
    case single
    case mixtape
    case freestyle
    case video
    case concert
    case showcase
    case festival
    case other

    var title: String {
        switch self {
        case .ep:
            return L10N.global.events.ep
        case .album:
            return L10N.global.events.album
        case .single:
            return L10N.global.events.single
        case .mixtape:
            return L10N.global.events.mixtape
        case .freestyle:
            return L10N.global.events.freestyle
        case .video:
            return L10N.global.events.video
        case .concert:
            return L10N.global.events.concert
        case .showcase:
            return L10N.global.events.showcase
        case .festival:
            return L10N.global.events.festival
        case .other:
            return L10N.global.events.other
        }
    }
}
