//
//  ArtistListCell.swift
//  Usiqee
//
//  Created by Amine on 07/04/2021.
//

import UIKit
import FirebaseUI

class ArtistListCell: UICollectionViewCell {

    //MARK: - Constant
    enum Constants {
        static let identifier = "ArtistListCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistImage: CircularImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        artistNameLabel.font = Fonts.AllArtist.Cell.title
    }
    
    func configure(item: ArtistBandBase) {
        artistNameLabel.text = item.name
        
        let storage = Storage.storage().reference(forURL: item.avatar)
        artistImage.sd_setImage(with: storage)
    }
}
