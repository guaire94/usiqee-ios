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
    
    //MARK: - Private
    private func set(name: String, font: UIFont) {
        artistNameLabel.text = name
        artistNameLabel.font = font
    }
    
    private func set(image: String) {
        let storage = Storage.storage().reference(forURL: image)
        artistImage.sd_setImage(with: storage)
    }
}
