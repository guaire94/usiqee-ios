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
    @IBOutlet weak private var discographyContainer: UIView!
    
    // MARK: - Properties
    var musicalEntity: MusicalEntity!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        segmentedMenu.configure(with: L10N.ArtistDetails.Menu.news, L10N.ArtistDetails.Menu.calendar, L10N.ArtistDetails.Menu.discography)
        segmentedMenu.delegate = self
    }
    
    // MARK: - Private
    private func setupView() {
        setupDescriptions()
        setupContent()
        resetMenuSubViews()
    }
    
    private func setupDescriptions() {
        nameLabel.font = Fonts.ArtistDetails.title
    }
    
    private func setupContent() {
        nameLabel.text = musicalEntity.name.uppercased()
        let storage = Storage.storage().reference(forURL: musicalEntity.avatar)
        fullImage.sd_setImage(with: storage)
        mainImage.sd_setImage(with: storage)
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
    
    private func resetMenuSubViews() {
        discographyContainer.isHidden = true
    }
}

// MARK: - IBActions
extension ArtistDetailsVC {
    @IBAction func onBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - MSegmentedMenuDelegate
extension ArtistDetailsVC: MSegmentedMenuDelegate {
    func didSelectItem(at index: Int) {
        resetMenuSubViews()
        
        switch index {
        case 0:
            break
        case 1:
            break
        case 2:
            discographyContainer.isHidden = false
        default:
            break
        }
    }
}
