//
//  ArtistDetailsVC.swift
//  Usiqee
//
//  Created by Amine on 18/04/2021.
//

import UIKit
import Firebase

fileprivate enum ContentType: Int {
    case bio = 0
    case news
    case calendar
}

class ArtistDetailsVC: UIViewController {

    // MARK: - Constants
    enum Constants {
        static let identifer = "ArtistDetailsVC"
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
    var musicalEntity: MusicalEntity!
    private var menuContentTableViewType: ContentType?
    private var relatedEvents: [RelatedEvent] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    deinit {
        ServiceArtist.detachRelatedEvents()
        ServiceBand.detachRelatedEvents()
    }
    
    // MARK: - Private
    private func setupView() {
        setupMenu()
        setupDescriptions()
        setupContent()
        setupTableView()
        setupListeners()
    }
    
    private func setupMenu() {
        segmentedMenu.configure(with: L10N.ArtistDetails.Menu.bio, L10N.ArtistDetails.Menu.news, L10N.ArtistDetails.Menu.calendar)
        segmentedMenu.delegate = self
        menuContentTableViewType = .bio
    }
    
    private func setupTableView() {
        menuContentTableView.register(ArtistDetailsEventCell.Constants.nib, forCellReuseIdentifier: ArtistDetailsEventCell.Constants.identifier)
        menuContentTableView.dataSource = self
    }
    
    private func setupListeners() {
        if let artist = musicalEntity as? Artist {
            ServiceArtist.listenToRelatedEvents(artist: artist, delegate: self)
        } else if let band = musicalEntity as? Band {
            ServiceBand.listenToRelatedEvents(band: band, delegate: self)
        }
    }
    
    private func setupDescriptions() {
        followingButton.layer.cornerRadius = Constants.followingCornerRadius
        nameLabel.font = Fonts.ArtistDetails.title
    }
    
    private func setupContent() {
        nameLabel.text = musicalEntity.name.uppercased()
        let storage = Storage.storage().reference(forURL: musicalEntity.avatar)
        fullImage.sd_setImage(with: storage)
        mainImage.sd_setImage(with: storage)
        setupFollowButton()
    }
    
    private func setupFollowButton() {
        if ManagerAuth.shared.isFollowing(musicalEntity: musicalEntity) {
            followingButton.isFilled = true
            followingButton.setTitle(L10N.ArtistDetails.unfollow, for: .normal)
        } else {
            followingButton.isFilled = false
            followingButton.setTitle(L10N.ArtistDetails.follow, for: .normal)
        }
    }
    
    private func setFollowersText(followers: Int) {
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(
            string: "\(followers) ",
            attributes: [
                .foregroundColor: Constants.followersNumber,
                .font: Fonts.ArtistDetails.followers
            ]))
        text.append(NSAttributedString(
            string: L10N.ArtistDetails.followed,
            attributes: [
                .foregroundColor: Constants.followersDescription,
                .font: Fonts.ArtistDetails.followers
            ])
        )

        follewersLabel.attributedText = text
    }
    
    private func handleFollowing() {
        let isFollowing = ManagerAuth.shared.isFollowing(musicalEntity: musicalEntity)
        if let artist = musicalEntity as? Artist {
            if isFollowing {
                followingButton.loadingIndicator(show: true)
                unfollow(artist: artist)
            } else {
                followingButton.loadingIndicator(show: true, backgroundColor: Colors.purple)
                follow(artist: artist)
            }
        } else if let band = musicalEntity as? Band {
            if isFollowing {
                followingButton.loadingIndicator(show: true)
                unfollow(band: band)
            } else {
                followingButton.loadingIndicator(show: true, backgroundColor: Colors.purple)
                follow(band: band)
            }
        }
    }
    
    private func follow(artist: Artist) {
        ServiceArtist.follow(artist: artist, completion: { [weak self] error in
            self?.didFinishFollowing(error)
        })
    }
    
    private func unfollow(artist: Artist) {
        guard let artistId = artist.id,
              let relatedArtist = ManagerAuth.shared.relatedArtist(by: artistId) else {
            return
        }
        ServiceArtist.unfollow(artist: relatedArtist) { [weak self] error in
            self?.didFinishFollowing(error)
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
        ServiceBand.unfollow(band: relatedBand) { [weak self] error in
            self?.didFinishFollowing(error)
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
extension ArtistDetailsVC {
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
extension ArtistDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = menuContentTableViewType else {
            return 0
        }
        
        switch type {
        case .bio:
            tableView.restore()
            return 0
        case .news:
            tableView.restore()
            return 0
        case .calendar:
            if relatedEvents.isEmpty {
                tableView.setEmptyMessage(L10N.ArtistDetails.Calendar.emptyListMessage)
            } else {
                tableView.restore()
            }
            
            return relatedEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = menuContentTableViewType else {
            return UITableViewCell()
        }
        
        switch type {
        case .bio:
            return UITableViewCell()
        case .news:
            return UITableViewCell()
        case .calendar:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistDetailsEventCell.Constants.identifier) as? ArtistDetailsEventCell else {
                return UITableViewCell()
            }
            
            cell.configure(event: relatedEvents[indexPath.row])
            return cell
        }
    }
}

// MARK: - MSegmentedMenuDelegate
extension ArtistDetailsVC: MSegmentedMenuDelegate {
    func didSelectItem(at index: Int) {
        menuContentTableViewType = ContentType(rawValue: index)
        menuContentTableView.reloadData()
    }
}

// MARK: - PreAuthVCDelegate
extension ArtistDetailsVC: PreAuthVCDelegate {
    func didSignIn() {
        setupFollowButton()
    }
}

// MARK: - ServiceArtistEventsDelegate
extension ArtistDetailsVC: ServiceArtistEventsDelegate, ServiceBandEventsDelegate {
    func dataAdded(event: RelatedEvent) {
        relatedEvents.append(event)
        menuContentTableView.reloadData()
    }
    
    func dataModified(event: RelatedEvent) {
        guard let index = relatedEvents.firstIndex(where: { $0.eventId == event.eventId }) else { return }
        relatedEvents[index] = event
        menuContentTableView.reloadData()
    }
    
    func dataRemoved(event: RelatedEvent) {
        guard let index = relatedEvents.firstIndex(where: { $0.eventId == event.eventId }) else { return }
        relatedEvents.remove(at: index)
        menuContentTableView.reloadData()
    }
}
