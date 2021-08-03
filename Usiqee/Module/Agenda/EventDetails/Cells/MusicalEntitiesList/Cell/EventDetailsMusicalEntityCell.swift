//
//  EventDetailsMusicalEntityCell.swift
//  Usiqee
//
//  Created by Amine on 30/07/2021.
//

import UIKit
import Firebase

class EventDetailsMusicalEntityCell: UICollectionViewCell {
    
    // MARK: - Constants
    enum Constants {
        static let identifier = "EventDetailsMusicalEntityCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        static let minimumWidthCell: CGFloat = 50
        fileprivate static let collectionViewWidthInsetCell: CGFloat = 5
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
    
    // MARK: - Helpers
    class func width(for musicalEntity: RelatedMusicalEntity) -> CGFloat {
        let width = musicalEntity.name.size(withAttributes: [NSAttributedString.Key.font : Fonts.EventDetails.musicalEntityName]).width + Constants.collectionViewWidthInsetCell
        return max(Constants.minimumWidthCell, width)
    }
}
