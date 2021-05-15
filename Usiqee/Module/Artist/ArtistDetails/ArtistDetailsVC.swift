//
//  ArtistDetailsVC.swift
//  Usiqee
//
//  Created by Amine on 18/04/2021.
//

import UIKit
import Firebase

class ArtistDetailsVC: UIViewController {

    // MARK: - Constants
    enum Constants {
        static let identifer = "ArtistDetailsVC"
        static let followersDescription: UIColor = Colors.gray
        static let followersNumber: UIColor = .white
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var segmentedMenu: MSegmentedMenu!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var follewersLabel: UILabel!
    @IBOutlet weak private var fullImage: UIImageView!
    @IBOutlet weak private var mainImage: CircularImageView!
    @IBOutlet weak private var followingButton: FilledButton!
    
    // MARK: - Properties
    var musicalEntity: MusicalEntity!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        segmentedMenu.configure(with: L10N.ArtistDetails.Menu.bio, L10N.ArtistDetails.Menu.news, L10N.ArtistDetails.Menu.calendar)
        segmentedMenu.delegate = self
    }
    
    // MARK: - Private
    private func setupView() {
        setupDescriptions()
        setupContent()
    }
    
    private func setupDescriptions() {
        followingButton.layer.cornerRadius = 15
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
        }else {
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
        guard let relatedArtist = ManagerAuth.shared.relatedArtist(by: artist.id!) else {
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
        guard let relatedBand = ManagerAuth.shared.relatedBand(by: band.id!) else {
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

// MARK: - MSegmentedMenuDelegate
extension ArtistDetailsVC: MSegmentedMenuDelegate {
    func didSelectItem(at index: Int) { }
}

// MARK: - PreAuthVCDelegate
extension ArtistDetailsVC: PreAuthVCDelegate {
    func didSignIn() {
        setupFollowButton()
    }
}
