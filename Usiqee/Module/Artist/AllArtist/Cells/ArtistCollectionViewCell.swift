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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        artistNameLabel.font = Fonts.AllArtist.Cell.title
    }
    
    func configure(artist: MusicalEntity) {
        artistNameLabel.text = artist.name
        
        let storage = Storage.storage().reference(forURL: artist.avatar)
        artistImage.sd_setImage(with: storage)
    }
}
