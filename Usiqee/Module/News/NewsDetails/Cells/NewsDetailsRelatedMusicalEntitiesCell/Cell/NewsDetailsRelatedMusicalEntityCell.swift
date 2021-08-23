//
//  NewsDetailsRelatedMusicalEntityCell.swift
//  Usiqee
//
//  Created by Amine on 18/08/2021.
//

import UIKit
import Firebase

class NewsDetailsRelatedMusicalEntityCell: UICollectionViewCell {
    
    // MARK: - Constants
    enum Constants {
        static let identifier = "NewsDetailsRelatedMusicalEntityCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var artistNameLabel: UILabel!
    @IBOutlet weak private var artistImage: CircularImageView!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        artistNameLabel.font = Fonts.EventDetails.musicalEntityName
    }
    
    func configure(musicalEntity: RelatedMusicalEntity) {
        artistNameLabel.text = musicalEntity.name
        let storage = Storage.storage().reference(forURL: musicalEntity.avatar)
        artistImage.sd_setImage(with: storage)
    }
}
