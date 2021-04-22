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
    @IBOutlet weak var segmentedMenu: MSegmentedMenu!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var follewersLabel: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    @IBOutlet weak var majorDescription: UILabel!
    @IBOutlet weak var majorContent: UILabel!
    @IBOutlet weak var groupDescription: UILabel!
    @IBOutlet weak var groupContent: UILabel!
    @IBOutlet weak var activityDescription: UILabel!
    @IBOutlet weak var activityContent: UILabel!
    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var mainImage: CircularImageView!
    @IBOutlet weak var groupContainer: UIView!
    
    // MARK: - Properties
    var item: ArtistBandBase!
    
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
        nameLabel.text = item.name.uppercased()
        labelContent.text = item.labelName
        activityContent.text = L10N.ArtistDetails.activityContent(from: item.startActivityDate.year)
        majorContent.text = item.majorName
        follewersLabel.text = L10N.ArtistDetails.followed(number: "1000")
        groupContainer.isHidden = true
        if item is Artist,
           let arist = item as? Artist,
           let groupName = arist.groupName {
            groupContent.text = groupName
            groupContainer.isHidden = false
        }
        
        let storage = Storage.storage().reference(forURL: item.avatar)
        fullImage.sd_setImage(with: storage)
        mainImage.sd_setImage(with: storage)
    }
}

// MARK: - IBActions
extension ArtistDetailsVC {
    @IBAction func onBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - MSegmentedMenuDelegate
extension ArtistDetailsVC: MSegmentedMenuDelegate {
    func didSelectItem(at index: Int) {
        
    }
}
