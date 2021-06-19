//
//  ArtistDetailsLabelCell.swift
//  Usiqee
//
//  Created by Amine on 17/06/2021.
//

import UIKit
import FirebaseUI

class ArtistDetailsLabelCell: UICollectionViewCell {

    //MARK: - Constant
    enum Constants {
        static let identifier = "ArtistDetailsLabelCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak private var labelNameLabel: UILabel!
    @IBOutlet weak private var labelImage: UIImageView!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        labelNameLabel.font = Fonts.ArtistDetails.Bio.description
    }
    
    func configure(label: RelatedLabel) {
        set(name: label.name)
        set(image: label.logo)
    }
    
    //MARK: - Private
    private func set(name: String) {
        labelNameLabel.text = name
    }
    
    private func set(image: String) {
        let storage = Storage.storage().reference(forURL: image)
        labelImage.sd_setImage(with: storage)
    }
}
