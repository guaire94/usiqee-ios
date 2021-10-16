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
    @IBOutlet weak private var loading: UIActivityIndicatorView!

    // MARK: - Properties
    var band: Band!
    private var tableviewHandler = BandDetailsTableViewHandler()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        HelperTracking.track(item: .bandDetails)
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
        menuContentTableView.register(ArtistDetailsNewsCell.Constants.nib, forCellReuseIdentifier: ArtistDetailsNewsCell.Constants.identifier)
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
        ServiceBand.listenToRelatedNews(band: band, delegate: self)
    }
    
    private func setupDescriptions() {
        followingButton.layer.cornerRadius = Constants.followingCornerRadius
        nameLabel.font = Fonts.ArtistDetails.title
        followingButton.titleLabel?.font = Fonts.ArtistDetails.followButton
    }
    
    private func setupContent() {
        nameLabel.text = band.name.uppercased()
        let storage = Storage.storage().reference(forURL: band.avatar)
        loading.startAnimating()
        fullImage.sd_setImage(with: storage, placeholderImage: nil) { [weak self] _, _, _, _ in
            self?.loading.stopAnimating()
        }
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
        HelperTracking.track(item: .bandDetailsFollow)
        ServiceBand.follow(band: band) { [weak self] error in
            self?.didFinishFollowing(error)
        }
    }
    
    private func unfollow(band: Band) {
        guard let bandId = band.id,
              let relatedBand = ManagerAuth.shared.relatedBand(by: bandId) else {
            return
        }
        HelperTracking.track(item: .bandDetailsUnfollow)
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
    
    private func showArtistDetails(with artist: Artist) {
        guard let vc = UIViewController.artistDetailsVC else { return }
        vc.artist = artist
        HelperTracking.track(item: .bandDetailsOpenArtist)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func syncRelatedNews(news: RelatedNews, completion: @escaping (RelatedNewsItem) -> Void) {
        ServiceNews.getNewsAuthor(newsId: news.newsId) { author in
            completion(RelatedNewsItem(news: news, author: author))
        }
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
        case let .news(news: news):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistDetailsNewsCell.Constants.identifier) as? ArtistDetailsNewsCell else {
                return defaultCell
            }
            cell.configure(item: news)
            return cell
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
            cell.configure(artists: tableviewHandler.relatedArtists, delegate: self)
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
        case .bio:
            return
        case let .news(news: news):
            guard let newsDetailsVC = UIViewController.newsDetailsVC else { return }
            HelperTracking.track(item: .bandDetailsOpenNews)
            ServiceNews.syncLikedNews(likedNews: news.news) { newsItem in
                DispatchQueue.main.async {
                    newsDetailsVC.news = newsItem
                    self.show(newsDetailsVC, sender: nil)
                }
            }
        case let .event(event: event):
            guard let eventDetailsVC = UIViewController.eventDetailsVC else { return }
            
            HelperTracking.track(item: .bandDetailsOpenEvent)
            eventDetailsVC.eventId = event.eventId
            present(eventDetailsVC, animated: true, completion: nil)
        }
    }
}

// MARK: - MSegmentedMenuDelegate
extension BandDetailsVC: MSegmentedMenuDelegate {
    func didSelectItem(at index: Int) {
        guard let type = ContentType(rawValue: index) else { return }
        
        switch type {
        case .bio:
            HelperTracking.track(item: .bandDetailsBio)
        case .news:
            HelperTracking.track(item: .bandDetailsNews)
        case .calendar:
            HelperTracking.track(item: .bandDetailsAgenda)
        }
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

// MARK: - BandDetailsMembersCellDelegate
extension BandDetailsVC: BandDetailsMembersCellDelegate {
    func didSelect(artist: RelatedArtist) {
        if let artist = ManagerMusicalEntity.shared.getArtist(by: artist.artistId) {
            showArtistDetails(with: artist)
            return
        }
        
        ServiceArtist.getArtist(artistId: artist.artistId){ [weak self] artist in
            guard let self = self,
                  let artist = artist else { return }
            self.showArtistDetails(with: artist)
        }
    }
}

// MARK: - ServiceBandNewsDelegate
extension BandDetailsVC: ServiceBandNewsDelegate {
    func dataAdded(news: RelatedNews) {
        syncRelatedNews(news: news) { [weak self] newsItem in
            self?.tableviewHandler.relatedNews.append(newsItem)
        }
    }
    
    func dataModified(news: RelatedNews) {
        guard let index = tableviewHandler.relatedNews.firstIndex(where: { $0.news.newsId == news.newsId }) else { return }
        syncRelatedNews(news: news) { [weak self] newsItem in
            self?.tableviewHandler.relatedNews[index] = newsItem
        }
    }
    
    func dataRemoved(news: RelatedNews) {
        guard let index = tableviewHandler.relatedNews.firstIndex(where: { $0.news.newsId == news.newsId }) else { return }
        tableviewHandler.relatedNews.remove(at: index)
    }
}
