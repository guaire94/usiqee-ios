//
//  EventDetailsCoverCell.swift
//  Usiqee
//
//  Created by Amine on 30/07/2021.
//

import UIKit
import Firebase

class EventDetailsCoverCell: UITableViewCell {

    // MARK: - Constant
    enum Constants {
        static let identifier: String = "EventDetailsCoverCell"
        static let nib: UINib = UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var coverImage: UIImageView!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImage.sd_cancelCurrentImageLoad()
        coverImage.image = nil
    }
    
    func configure(cover: String) {
        let storage = Storage.storage().reference(forURL: cover)
        coverImage.sd_setImage(with: storage, placeholderImage: UIImage.placeHolderRect)
    }
}
