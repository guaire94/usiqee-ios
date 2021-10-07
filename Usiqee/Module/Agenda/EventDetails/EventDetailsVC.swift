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
    @IBOutlet weak private var loaderView: UIView!
    @IBOutlet weak private var tableview: UITableView!
    @IBOutlet weak private var addToCalendarButton: UIButton!
    @IBOutlet weak private var showDetailsButton: UIButton!
    
    // MARK: - Properties
    var event: EventItem?
    var eventId: String?
    private var tableViewHandler: EventDetailsTableViewHandler = EventDetailsTableViewHandler()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let eventType = event?.event.eventType else { return }
        HelperTracking.track(item: .agendaEventDetails(type: eventType))
        setupView()
    }
    
    // MARK: - Private
    private func setupView() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        setupTableView()
        setupFooterButtons()
        setupEvent()
    }
    
    private func setupTableView() {
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(EventDetailsOverviewCell.Constants.nib, forCellReuseIdentifier: EventDetailsOverviewCell.Constants.identifier)
        tableview.register(EventDetailsDateAndLocationCell.Constants.nib, forCellReuseIdentifier: EventDetailsDateAndLocationCell.Constants.identifier)
        tableview.register(EventDetailsCoverCell.Constants.nib, forCellReuseIdentifier: EventDetailsCoverCell.Constants.identifier)
        tableview.register(EventDetailsMusicalEntitiesListCell.Constants.nib, forCellReuseIdentifier: EventDetailsMusicalEntitiesListCell.Constants.identifier)
    }
    
    private func setupFooterButtons() {
        addToCalendarButton.titleLabel?.font = Fonts.EventDetails.button
        showDetailsButton.titleLabel?.font = Fonts.EventDetails.button
        addToCalendarButton.setTitle(L10N.EventDetails.addToCalendar, for: .normal)
        showDetailsButton.setTitle(L10N.EventDetails.showDetails, for: .normal)
    }
    
    private func setupEvent() {
        guard let eventId = eventId else {
            displayEventInformation()
            return
        }
        
        loaderView.isHidden = false
        loadEventInformation(eventId)
    }
    
    private func displayEventInformation() {
        guard let item = event else { return }
        
        tableViewHandler.event = item
        showDetailsButton.setTitle(tableViewHandler.redirectionButtonText, for: .normal)
        tableview.reloadData()
        showDetailsButton.isHidden = isShowDetailsButtonHidden(webLink: item.event.webLink)
        loaderView.isHidden = true
    }
    
    private func loadEventInformation(_ eventId: String) {
        ServiceEvents.load(eventId: eventId) { [weak self] event in
            guard let self = self else { return }
            
            self.event = event
            self.displayEventInformation()
        }
    }
    
    private func isShowDetailsButtonHidden(webLink: String?) -> Bool {
        guard let urlString = webLink,
              let url = URL(string: urlString) else {
            return true
        }
        
        return !UIApplication.shared.canOpenURL(url)
    }
}

// MARK: - UITableViewDataSource
extension EventDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHandler.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = tableViewHandler.item(for: indexPath) else {
            return UITableViewCell()
        }
        
        switch cellType {
        case let .overview(information: information):
            guard let cell = tableview.dequeueReusableCell(withIdentifier: EventDetailsOverviewCell.Constants.identifier) as? EventDetailsOverviewCell else {
                return UITableViewCell()
            }
            
            cell.configure(information: information)
            return cell
        case let .dateAndLocation(event: event):
            guard let cell = tableview.dequeueReusableCell(withIdentifier: EventDetailsDateAndLocationCell.Constants.identifier) as? EventDetailsDateAndLocationCell else {
                return UITableViewCell()
            }
            
            cell.configure(event: event)
            return cell
        case let .cover(url: cover):
            guard let cell = tableview.dequeueReusableCell(withIdentifier: EventDetailsCoverCell.Constants.identifier) as? EventDetailsCoverCell else {
                return UITableViewCell()
            }
            
            cell.configure(cover: cover)
            return cell
        case let .musicalEntitiesList(musicalEntities: musicalEntities):
            guard let cell = tableview.dequeueReusableCell(withIdentifier: EventDetailsMusicalEntitiesListCell.Constants.identifier) as? EventDetailsMusicalEntitiesListCell else {
                return UITableViewCell()
            }
            
            cell.configure(musicalEntities: musicalEntities, delegate: self)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension EventDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewHandler.heightForRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let musicalEntity = event?.musicalEntity,
              let cellType = tableViewHandler.item(for: indexPath) else {
            return
        }
        
        switch cellType {
        case .overview:
            didSelect(musicalEntity: musicalEntity)
            break
        default:
            break
        }
    }
}

// MARK: - IBActions
extension EventDetailsVC {
    @IBAction func onCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddToCalendarTapped(_ sender: Any) {
        guard let eventItem = event else { return }
        
        HelperTracking.track(item: .agendaEventDetailsAddToCalendar)
        let eventStore = EKEventStore()
        eventStore.requestAccess( to: EKEntityType.event, completion:{ granted, error in
            DispatchQueue.main.async {
                guard granted, error == nil else {
                    self.showError(title: L10N.EventDetails.title, message: L10N.EventDetails.addToCalendarError)
                    return
                }
                
                guard let event = eventItem.createEvent(with: eventStore) else {
                    return
                }
                
                let eventController = EKEventEditViewController()
                eventController.event = event
                eventController.eventStore = eventStore
                eventController.editViewDelegate = self
                self.present(eventController, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func onShowDetailsTapped(_ sender: Any) {
        guard let urlString = event?.event.webLink,
              let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else { return }
        
        HelperTracking.track(item: .agendaEventDetailsMoreInfos)

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

// MARK: - EventDetailsMusicalEntitiesListCellDelegate
extension EventDetailsVC: EventDetailsMusicalEntitiesListCellDelegate {
    func didSelect(musicalEntity: RelatedMusicalEntity) {
        if let artist = musicalEntity as? RelatedArtist {
            ServiceArtist.getArtist(artistId: artist.artistId) { [weak self] artist in
                guard let self = self,
                      let artistVC = UIViewController.artistDetailsVC else { return }
                artistVC.artist = artist
                HelperTracking.track(item: .agendaEventDetailsOpenArtist)
                self.navigationController?.pushViewController(artistVC, animated: true)
            }
            return
        }
        
        if let band = musicalEntity as? RelatedBand {
            ServiceBand.getBand(bandId: band.bandId) { [weak self] band in
                guard let self = self,
                      let bandVC = UIViewController.bandDetailsVC else { return }
                bandVC.band = band
                HelperTracking.track(item: .agendaEventDetailsOpenBand)
                self.navigationController?.pushViewController(bandVC, animated: true)
            }
        }
    }
}
