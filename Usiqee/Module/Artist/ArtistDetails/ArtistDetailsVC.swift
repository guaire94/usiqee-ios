//
//  ArtistDetailsVC.swift
//  Usiqee
//
//  Created by Amine on 18/04/2021.
//

import UIKit
import Firebase

class ArtistDetailsVC: UIViewController {
    
    enum ContentType: Int {
        case bio = 0
        case news
        case calendar
    }
    
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
    var artist: Artist!
    private var tableviewHandler = ArtistDetailsTableViewHandler()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        HelperTracking.track(item: .artistDetails)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupContent()
    }

    deinit {
        ServiceArtist.detachRelatedListeners()
    }
    
    // MARK: - Private
    private func setupView() {
        setupTableViewHelper()
        setupMenu()
        setupDescriptions()
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
        menuContentTableView.register(ArtistDetailsGroupesCell.Constants.nib, forCellReuseIdentifier: ArtistDetailsGroupesCell.Constants.identifier)
        menuContentTableView.register(ArtistDetailsLabelsCell.Constants.nib, forCellReuseIdentifier: ArtistDetailsLabelsCell.Constants.identifier)
        menuContentTableView.register(ArtistDetailsNewsCell.Constants.nib, forCellReuseIdentifier: ArtistDetailsNewsCell.Constants.identifier)
        menuContentTableView.dataSource = self
        menuContentTableView.delegate = self
        menuContentTableView.tableFooterView = nil
    }
    
    private func setupTableViewHelper() {
        tableviewHandler.delegate = self
        tableviewHandler.artist = artist
    }
    
    private func setupListeners() {
        ServiceArtist.listenToRelatedEvents(artist: artist, delegate: self)
        ServiceArtist.listenToRelatedLabels(artist: artist, delegate: self)
        ServiceArtist.listenToRelatedBand(artist: artist, delegate: self)
        ServiceArtist.listenToRelatedNews(artist: artist, delegate: self)
    }
    
    private func setupDescriptions() {
        followingButton.layer.cornerRadius = Constants.followingCornerRadius
        nameLabel.font = Fonts.ArtistDetails.title
        followingButton.titleLabel?.font = Fonts.ArtistDetails.followButton
    }
    
    private func setupContent() {
        nameLabel.text = artist.name.uppercased()
        let storage = Storage.storage().reference(forURL: artist.avatar)
        mainImage.sd_setImage(with: storage)
        
        fullImage.withShimmer = true
        fullImage.startShimmerAnimation()
        fullImage.sd_setImage(with: storage, placeholderImage: nil) { (_, _, _, _) in
            self.fullImage.stopShimmerAnimation()
        }

        setupFollowButton()
    }
    
    private func setupFollowButton() {
        if ManagerAuth.shared.isFollowing(musicalEntity: artist) {
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
        let isFollowing = ManagerAuth.shared.isFollowing(musicalEntity: artist)
        if isFollowing {
            followingButton.loadingIndicator(show: true)
            unfollow(artist: artist)
        } else {
            followingButton.loadingIndicator(show: true, backgroundColor: Colors.purple)
            follow(artist: artist)
        }
    }
    
    private func follow(artist: Artist) {
        HelperTracking.track(item: .artistDetailsFollow)
        ServiceArtist.follow(artist: artist, completion: { [weak self] error in
            self?.didFinishFollowing(error)
        })
    }
    
    private func unfollow(artist: Artist) {
        guard let artistId = artist.id,
              let relatedArtist = ManagerAuth.shared.relatedArtist(by: artistId) else {
            return
        }
        HelperTracking.track(item: .artistDetailsUnfollow)
        ServiceArtist.unfollow(artist: relatedArtist) { [weak self] error in
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
    
    private func showBandDetails(with band: Band) {
        guard let vc = UIViewController.bandDetailsVC else { return }
        vc.band = band
        HelperTracking.track(item: .artistDetailsOpenBand)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func syncRelatedNews(news: RelatedNews, completion: @escaping (RelatedNewsItem) -> Void) {
        ServiceNews.getNewsAuthor(newsId: news.newsId) { author in
            completion(RelatedNewsItem(news: news, author: author))
        }
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
            cell.configure(artist: artist)
            return cell
        case let .bio(cellType) where cellType == .group:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArtistDetailsGroupesCell.Constants.identifier) as? ArtistDetailsGroupesCell else {
                return defaultCell
            }
            cell.configure(bands: tableviewHandler.relatedBands, delegate: self)
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
extension ArtistDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = tableviewHandler.item(for: indexPath) else { return }
        
        switch item {
        case .bio:
            return
        case let .news(news: news):
            guard let newsDetailsVC = UIViewController.newsDetailsVC else { return }
            
            ServiceNews.syncLikedNews(likedNews: news.news) { newsItem in
                DispatchQueue.main.async {
                    newsDetailsVC.news = newsItem
                    HelperTracking.track(item: .artistDetailsOpenNews)
                    self.show(newsDetailsVC, sender: nil)
                }
            }
        case let .event(event: event):
            guard let eventDetailsVC = UIViewController.eventDetailsVC else { return }
            
            eventDetailsVC.eventId = event.eventId
            HelperTracking.track(item: .artistDetailsOpenEvent)
            present(eventDetailsVC, animated: true, completion: nil)
        }
    }
}

// MARK: - MSegmentedMenuDelegate
extension ArtistDetailsVC: MSegmentedMenuDelegate {
    func didSelectItem(at index: Int) {
        guard let type = ContentType(rawValue: index) else { return }
        
        switch type {
        case .bio:
            HelperTracking.track(item: .artistDetailsBio)
        case .news:
            HelperTracking.track(item: .artistDetailsNews)
        case .calendar:
            HelperTracking.track(item: .artistDetailsAgenda)
        }

        tableviewHandler.tableViewType = type
    }
}

// MARK: - PreAuthVCDelegate
extension ArtistDetailsVC: PreAuthVCDelegate {
    func didSignIn() {
        setupFollowButton()
    }
}

// MARK: - ServiceArtistEventsDelegate
extension ArtistDetailsVC: ServiceArtistEventsDelegate {
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

// MARK: - ServiceArtistLabelsDelegate
extension ArtistDetailsVC: ServiceArtistLabelsDelegate {
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

// MARK: - ServiceArtistBandsDelegate
extension ArtistDetailsVC: ServiceArtistBandsDelegate {
    func dataAdded(band: RelatedBand) {
        tableviewHandler.relatedBands.append(band)
    }
    
    func dataModified(band: RelatedBand) {
        guard let index = tableviewHandler.relatedBands.firstIndex(where: { $0.bandId == band.bandId }) else { return }
        tableviewHandler.relatedBands[index] = band
    }
    
    func dataRemoved(band: RelatedBand) {
        guard let index = tableviewHandler.relatedBands.firstIndex(where: { $0.bandId == band.bandId }) else { return }
        tableviewHandler.relatedBands.remove(at: index)
    }
}

// MARK: - ServiceArtistNewsDelegate
extension ArtistDetailsVC: ServiceArtistNewsDelegate {
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

// MARK: - ArtistDetailsTableViewHandlerDelegate
extension ArtistDetailsVC: ArtistDetailsTableViewHandlerDelegate {
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

// MARK: - ArtistDetailsGroupesCellDelegate
extension ArtistDetailsVC: ArtistDetailsGroupesCellDelegate {
    func didSelect(band: RelatedBand) {
        if let band = ManagerMusicalEntity.shared.getBand(by: band.bandId) {
            showBandDetails(with: band)
            return
        }
        
        ServiceBand.getBand(bandId: band.bandId) { [weak self] band in
            guard let self = self,
                  let band = band else { return }
            self.showBandDetails(with: band)
        }
    }
}
