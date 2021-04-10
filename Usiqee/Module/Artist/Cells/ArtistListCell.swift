//
//  ArtistListCell.swift
//  Usiqee
//
//  Created by Amine on 07/04/2021.
//

import UIKit
import Kingfisher

class ArtistListCell: UICollectionViewCell {

    //MARK: - Constant
    enum Constants {
        static let identifier = "ArtistListCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistImage: CircularImageView!
    
    func configure(item: ArtistListItem) {
        artistNameLabel.text = item.name
        
        guard let url = URL(string: item.avatar) else {
            return
        }
        
        artistImage.kf.setImage(with: url)
    }
}

class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}
