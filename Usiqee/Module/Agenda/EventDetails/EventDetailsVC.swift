//
//  EventDetailsVC.swift
//  Usiqee
//
//  Created by Amine on 06/06/2021.
//

import UIKit
import Firebase
import SafariServices
import EventKitUI

class EventDetailsVC: UIViewController {

    // MARK: - Constants
    enum Constants {
        static let identifer: String = "EventDetailsVC"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var artistImage: UIImageView!
    @IBOutlet weak private var artistNameLabel: UILabel!
    @IBOutlet weak private var typeLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var addToCalendarButton: UIButton!
    @IBOutlet weak private var showDetailsButton: UIButton!
    
    // MARK: - Properties
    var event: EventItem?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - Private
    private func setupView() {
        setupFonts()
        setupDescription()
        displayEventInformation()
    }
    
    private func setupFonts() {
        artistNameLabel.font = Fonts.EventDetails.name
        descriptionLabel.font = Fonts.EventDetails.description
        typeLabel.font = Fonts.EventDetails.type
        dateLabel.font = Fonts.EventDetails.date
        timeLabel.font = Fonts.EventDetails.time
        addToCalendarButton.titleLabel?.font = Fonts.EventDetails.button
        showDetailsButton.titleLabel?.font = Fonts.EventDetails.button
    }
    
    private func setupDescription() {
        addToCalendarButton.setTitle(L10N.EventDetails.addToCalendar, for: .normal)
        showDetailsButton.setTitle(L10N.EventDetails.showDetails, for: .normal)
    }
    
    private func displayEventInformation() {
        guard let item = event else { return }
        
        descriptionLabel.text = item.event.title
        typeLabel.text = item.event.eventType?.title
        dateLabel.text = item.event.date.dateValue().full
        timeLabel.text = item.event.date.dateValue().time
        showDetailsButton.isHidden = item.event.webLink == nil
        if let musicalEntity = getMusicalEntity(item: item) {
            let storage = Storage.storage().reference(forURL: musicalEntity.avatar)
            artistImage.sd_setImage(with: storage)
            artistNameLabel.text = musicalEntity.name
        }
    }
    
    private func getMusicalEntity(item: EventItem) -> RelatedMusicalEntity? {
        if let artist = item.artists.first {
            return artist
        }

        if let band = item.bands.first {
            return band
        }
        
        return nil
    }
    
    private func addEvent(eventStore: EKEventStore, eventItem: EventItem, musicalEntity: RelatedMusicalEntity) {
        let event = EKEvent(eventStore: eventStore)
        var title = "\(musicalEntity.name) - \(eventItem.event.title)"
        if let eventType = eventItem.event.eventType {
            title += " - \(eventType)"
        }
        event.title = title
        event.startDate = eventItem.event.date.dateValue()
        event.endDate = eventItem.event.date.dateValue()
        
        let eventController = EKEventEditViewController()
        eventController.event = event
        eventController.eventStore = eventStore
        eventController.editViewDelegate = self
        present(eventController, animated: true, completion: nil)
    }
}

// MARK: - IBActions
extension EventDetailsVC {
    @IBAction func onCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddToCalendarTapped(_ sender: Any) {
        guard let eventItem = event,
              let musicalEntity = getMusicalEntity(item: eventItem) else { return }
        
        let eventStore = EKEventStore()
        eventStore.requestAccess( to: EKEntityType.event, completion:{ granted, error in
            DispatchQueue.main.async {
                guard granted, error == nil else {
                    self.showError(title: L10N.EventDetails.title, message: L10N.EventDetails.addToCalendarError)
                    return
                }
                
                self.addEvent(eventStore: eventStore, eventItem: eventItem, musicalEntity: musicalEntity)
            }
        })
    }
    
    @IBAction func onShowDetailsTapped(_ sender: Any) {
        guard let urlString = event?.event.webLink,
              let url = URL(string: urlString) else { return }
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let vc = SFSafariViewController(url: url, configuration: config)
        if #available(iOS 13.0, *) {
            vc.modalPresentationStyle = .automatic
        }
        present(vc, animated: true)
    }
}

// MARK: - EKEventEditViewDelegate
extension EventDetailsVC: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}
