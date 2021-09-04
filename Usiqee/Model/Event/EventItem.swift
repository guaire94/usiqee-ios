//
//  EventItem.swift
//  Usiqee
//
//  Created by Amine on 10/06/2021.
//

import EventKitUI

struct EventItem {
    
    // MARK: - Properties
    let event: Event
    let artists: [RelatedArtist]
    let bands: [RelatedBand]
    let mainArtist: RelatedArtist?
    let mainBand: RelatedBand?
    
    // MARK: - Helper
    var musicalEntity: RelatedMusicalEntity? {
        if mainArtist != nil {
            return mainArtist
        }
        
        if mainBand != nil {
            return mainBand
        }

        return nil
    }
    
    func createEvent(with eventStore: EKEventStore) -> EKEvent? {
        guard let musicalEntity = musicalEntity else {
            return nil
        }
        
        let event = EKEvent(eventStore: eventStore)
        var title = "\(musicalEntity.name) - \(self.event.title)"
        if let eventType = self.event.eventType {
            title += " - \(eventType)"
        }
        event.title = title
        event.startDate = self.event.date.dateValue()
        event.endDate = self.event.date.dateValue()
        event.isAllDay = true
        if let urlString = self.event.webLink,
           let url = URL(string: urlString) {
            event.url = url
        }
        
        return event
    }
}
