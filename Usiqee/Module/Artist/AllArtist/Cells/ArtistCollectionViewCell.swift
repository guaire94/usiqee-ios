//
//  ArtistListCell.swift
//  Usiqee
//
//  Created by Amine on 07/04/2021.
//

import UIKit
import FirebaseUI

class ArtistCollectionViewCell: UICollectionViewCell {

    //MARK: - Constant
    enum Constants {
        static let identifier = "ArtistCollectionViewCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak private var artistNameLabel: UILabel!
    @IBOutlet weak private var artistImage: CircularImageView!
    
    // MARK: - Public
    func configure(artist: MusicalEntity) {
        set(name: artist.name, font: Fonts.AllArtist.Cell.title)
        set(image: artist.avatar)
    }
    
    func configure(followedEntity: RelatedMusicalEntity) {
        set(name: followedEntity.name, font: Fonts.FollowedArtist.Cell.title)
        set(image: followedEntity.avatar)
    }
    
    func configure(relatedBand: RelatedBand) {
        set(name: relatedBand.name, font: Fonts.ArtistDetails.Bio.description, textColor: Colors.gray)
        set(image: relatedBand.avatar)
    }
    
    func configure(relatedArtist: RelatedArtist) {
        set(name: relatedArtist.name, font: Fonts.ArtistDetails.Bio.description, textColor: Colors.gray)
        set(image: relatedArtist.avatar)
    }
    
    //MARK: - Private
    private func set(name: String, font: UIFont, textColor: UIColor = .white) {
        artistNameLabel.text = name
        artistNameLabel.font = font
        artistNameLabel.textColor = textColor
    }
    
    private func set(image: String) {
        let storage = Storage.storage().reference(forURL: image)
        artistImage.sd_setImage(with: storage)
    }
}
