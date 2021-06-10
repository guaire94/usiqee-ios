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
            return L10N.Events.types.ep
        case .album:
            return L10N.Events.types.album
        case .single:
            return L10N.Events.types.single
        case .mixtape:
            return L10N.Events.types.mixtape
        case .freestyle:
            return L10N.Events.types.freestyle
        case .video:
            return L10N.Events.types.video
        case .concert:
            return L10N.Events.types.concert
        case .showcase:
            return L10N.Events.types.showcase
        case .festival:
            return L10N.Events.types.festival
        case .other:
            return L10N.Events.types.other
        }
    }
}
