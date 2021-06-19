//
//  BandDetailsVC.swift
//  Usiqee
//
//  Created by Amine on 17/06/2021.
//

import UIKit
import Firebase

class BandDetailsVC: UIViewController {
    
    enum ContentType: Int {
        case bio = 0
        case news
        case calendar
    }
    
    // MARK: - Constants
    enum Constants {
        static let identifer = "BandDetailsVC"
        fileprivate static let followersDescription: UIColor = Colors.gray
        fileprivate static let followersNumber: UIColor = .white
        fileprivate static let followingCornerRadius: CGFloat = 15
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var segmentedMenu: MSegmentedMenu!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var follewersLabel: UILabel!
    @IBOutlet weak private var fullImage: UIImageView!
    @IBOutlet weak private var mainImage: CircularImageView!
    @IBOutlet weak private var followingButton: FilledButton!
    @IBOutlet weak private var menuContentTableView: UITableView!

    // MARK: - Properties
    var band: Band!
    private var tableviewHandler = BandDetailsTableViewHandler()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    deinit {
        ServiceBand.detachRelatedListeners()
    }
    
    // MARK: - Private
    private func setupView() {
        setupTableViewHelper()
        setupMenu()
        setupDescriptions()
        setupContent()
        setupTableView()
        setupListeners()
    }
    
    private func setupMenu() {
        segmentedMenu.configure(with: L10N.ArtistDetails.Menu.bio, L10N.ArtistDetails.Menu.news, L10N.ArtistDetails.Menu.calendar)
        segmentedMenu.delegate = self
        tableviewHandler.tableViewType = .bio
    }
    
    private func setupTableView() {
        menuContentTableView.register(ArtistDetailsEventCell.Constants.nib, forCellReuseIdentifier: ArtistDetailsEventCell.Constants.identifier)
        menuContentTableView.register(ArtistDetailsInformationCell.Constants.nib, forCellReuseIdentifier: ArtistDetailsInformationCell.Constants.identifier)
        menuContentTableView.register(BandDetailsMembersCell.Constants.nib, forCellReuseIdentifier: BandDetailsMembersCell.Constants.identifier)
        menuContentTableView.register(ArtistDetailsLabelsCell.Constants.nib, forCellReuseIdentifier: ArtistDetailsLabelsCell.Constants.identifier)
        menuContentTableView.dataSource = self
        menuContentTableView.delegate = self
        menuContentTableView.tableFooterView = nil
    }
    
    private func setupTableViewHelper() {
        tableviewHandler.delegate = self
        tableviewHandler.band = band
    }
    
    private func setupListeners() {
        ServiceBand.listenToRelatedEvents(band: band, delegate: self)
        ServiceBand.listenToRelatedLabels(band: band, delegate: self)
        ServiceBand.listenToRelatedMembers(band: band, delegate: self)
    }
    
    private func setupDescriptions() {
        followingButton.layer.cornerRadius = Constants.followingCornerRadius
        nameLabel.font = Fonts.ArtistDetails.title
        followingButton.titleLabel?.font = Fonts.ArtistDetails.followButton
    }
    
    private func setupContent() {
        nameLabel.text = band.name.uppercased()
        let storage = Storage.storage().reference(forURL: band.avatar)
        fullImage.sd_setImage(with: storage)
        mainImage.sd_setImage(with: storage)
        setupFollowButton()
    }
    
    private func setupFollowButton() {
        if ManagerAuth.shared.isFollowing(musicalEntity: band) {
            followingButton.isFilled = true
            followingButton.setTitle(L10N.ArtistDetails.unfollow, for: .normal)
        } else {
            followingButton.isFilled = false
            followingButton.setTitle(L10N.ArtistDetails.follow, for: .normal)
        }
    }
    
    private func handleFollowing() {
        let isFollowing = ManagerAuth.shared.isFollowing(musicalEntity: band)
        if isFollowing {
            followingButton.loadingIndicator(show: true)
            unfollow(band: band)
        } else {
            followingButton.loadingIndicator(show: true, backgroundColor: Colors.purple)
            follow(band: band)
        }
    }
    
    private func follow(band: Band) {
        ServiceBand.follow(band: band) { [weak self] error in
            self?.didFinishFollowing(error)
        }
    }
    
    private func unfollow(band: Band) {
        guard let bandId = band.id,
              let relatedBand = ManagerAuth.shared.relatedBand(by: bandId) else {
            return
        }
        ServiceBand.unfollow(band: relatedBand) { [weak self] error in self?.didFinishFollowing(error)
        }
    }
    
    private func didFinishFollowing(_ error: Error?) {
        followingButton.loadingIndicator(show: false)
        
        if let error = error {
            self.showError(title: L10N.ArtistDetails.title, message: error.localizedDescription)
            return
        }
        
        setupFollowButton()
    }
}

// MARK: - IBActions
extension BandDetailsVC {
    @IBAction func onBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onFollowTapped(_ sender: Any) {
        guard ManagerAuth.shared.isConnected else {
            displayAuthentication(with: self)
            return
        }
        
        handleFollowing()
    }
}

// MARK: - UITableViewDataSource
extension BandDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableviewHandler.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        
        guard let item = tableviewHandler.item(for: indexPath) else {
            return defaultCell
        }
        
        switch item {
        case .news:
            return defaultCell
        case let .bio(cellType) where cellType == .information:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistDetailsInformationCell.Constants.identifier) as? ArtistDetailsInformationCell else {
                return defaultCell
            }
            cell.configure(band: band)
            return cell
        case let .bio(cellType) where cellType == .member:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BandDetailsMembersCell.Constants.identifier) as? BandDetailsMembersCell else {
                return defaultCell
            }
            cell.configure(artists: tableviewHandler.relatedArtists)
            return cell
        case let .bio(cellType) where cellType == .label:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistDetailsLabelsCell.Constants.identifier) as? ArtistDetailsLabelsCell else {
                return defaultCell
            }
            cell.configure(labels: tableviewHandler.relatedLabels)
            return cell
        case let .event(event: event):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistDetailsEventCell.Constants.identifier) as? ArtistDetailsEventCell else {
                return defaultCell
            }
            
            cell.configure(event: event)
            return cell
        default:
            return defaultCell
        }
    }
}

// MARK: - UITableViewDelegate
extension BandDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = tableviewHandler.item(for: indexPath) else { return }
        
        switch item {
        case .bio, .news:
            return
        case let .event(event: event):
            guard let eventDetailsVC = UIViewController.eventDetailsVC else {
                return
            }
            
            eventDetailsVC.eventId = event.eventId
            present(eventDetailsVC, animated: true, completion: nil)
        }
    }
}

// MARK: - MSegmentedMenuDelegate
extension BandDetailsVC: MSegmentedMenuDelegate {
    func didSelectItem(at index: Int) {
        guard let type = ContentType(rawValue: index) else { return }
        tableviewHandler.tableViewType = type
    }
}

// MARK: - PreAuthVCDelegate
extension BandDetailsVC: PreAuthVCDelegate {
    func didSignIn() {
        setupFollowButton()
    }
}

// MARK: - ServiceBandEventsDelegate
extension BandDetailsVC: ServiceBandEventsDelegate {
    func dataAdded(event: RelatedEvent) {
        tableviewHandler.relatedEvents.append(event)
    }
    
    func dataModified(event: RelatedEvent) {
        guard let index = tableviewHandler.relatedEvents.firstIndex(where: { $0.eventId == event.eventId }) else { return }
        tableviewHandler.relatedEvents[index] = event
    }
    
    func dataRemoved(event: RelatedEvent) {
        guard let index = tableviewHandler.relatedEvents.firstIndex(where: { $0.eventId == event.eventId }) else { return }
        tableviewHandler.relatedEvents.remove(at: index)
    }
}

// MARK: - ServiceBandLabelsDelegate
extension BandDetailsVC: ServiceBandLabelsDelegate {
    func dataAdded(label: RelatedLabel) {
        tableviewHandler.relatedLabels.append(label)
    }
    
    func dataModified(label: RelatedLabel) {
        guard let index = tableviewHandler.relatedLabels.firstIndex(where: { $0.labelId == label.labelId }) else { return }
        tableviewHandler.relatedLabels[index] = label
    }
    
    func dataRemoved(label: RelatedLabel) {
        guard let index = tableviewHandler.relatedLabels.firstIndex(where: { $0.labelId == label.labelId }) else { return }
        tableviewHandler.relatedLabels.remove(at: index)
    }
}

// MARK: - ServiceBandMembersDelegate
extension BandDetailsVC: ServiceBandMembersDelegate {
    func dataAdded(artist: RelatedArtist) {
        tableviewHandler.relatedArtists.append(artist)
    }
    
    func dataModified(artist: RelatedArtist) {
        guard let index = tableviewHandler.relatedArtists.firstIndex(where: { $0.artistId == artist.artistId }) else { return }
        tableviewHandler.relatedArtists[index] = artist
    }
    
    func dataRemoved(artist: RelatedArtist) {
        guard let index = tableviewHandler.relatedArtists.firstIndex(where: { $0.artistId == artist.artistId }) else { return }
        tableviewHandler.relatedArtists.remove(at: index)
    }
}

// MARK: - BandDetailsTableViewHandlerDelegate
extension BandDetailsVC: BandDetailsTableViewHandlerDelegate {
    func reloadData() {
        menuContentTableView.reloadData()
    }
    
    func setEmptyMessage(_ message: String) {
        menuContentTableView.setEmptyMessage(message)
    }
    
    func restore() {
        menuContentTableView.restore()
    }
}
