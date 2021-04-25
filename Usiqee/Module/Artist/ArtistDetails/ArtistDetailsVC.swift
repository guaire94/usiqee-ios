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
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var segmentedMenu: MSegmentedMenu!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var follewersLabel: UILabel!
    @IBOutlet weak private var labelDescription: UILabel!
    @IBOutlet weak private var labelContent: UILabel!
    @IBOutlet weak private var majorDescription: UILabel!
    @IBOutlet weak private var majorContent: UILabel!
    @IBOutlet weak private var groupDescription: UILabel!
    @IBOutlet weak private var groupContent: UILabel!
    @IBOutlet weak private var activityDescription: UILabel!
    @IBOutlet weak private var activityContent: UILabel!
    @IBOutlet weak private var fullImage: UIImageView!
    @IBOutlet weak private var mainImage: CircularImageView!
    @IBOutlet weak private var groupContainer: UIView!
    
    // MARK: - Properties
    var musicalEntity: MusicalEntity!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        segmentedMenu.delegate = self
    }
    
    private func setupView() {
        setupDescriptions()
        setupContent()
    }
    
    private func setupDescriptions() {
        nameLabel.font = Fonts.ArtistDetails.title
        labelContent.font = Fonts.ArtistDetails.label
        groupContent.font = Fonts.ArtistDetails.group
        activityContent.font = Fonts.ArtistDetails.activity
        majorContent.font = Fonts.ArtistDetails.major
        follewersLabel.font = Fonts.ArtistDetails.followers
        
        labelDescription.text = L10N.ArtistDetails.label
        groupDescription.text = L10N.ArtistDetails.group
        activityDescription.text = L10N.ArtistDetails.activity
        majorDescription.text = L10N.ArtistDetails.major
    }
    
    private func setupContent() {
        nameLabel.text = musicalEntity.name.uppercased()
        labelContent.text = musicalEntity.labelName
        activityContent.text = L10N.ArtistDetails.activityContent(from: musicalEntity.startActivityDate.year)
        majorContent.text = musicalEntity.majorName
        follewersLabel.text = L10N.ArtistDetails.followed(number: "1000")
        groupContainer.isHidden = true
        if let arist = musicalEntity as? Artist,
           let groupName = arist.groupName {
            groupContent.text = groupName
            groupContainer.isHidden = false
        }
        
        let storage = Storage.storage().reference(forURL: musicalEntity.avatar)
        fullImage.sd_setImage(with: storage)
        mainImage.sd_setImage(with: storage)
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
        
    }
}
