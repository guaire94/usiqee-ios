//
//  NewsDetailsImageCell.swift
//  Usiqee
//
//  Created by Amine on 06/07/2021.
//

import UIKit
import Firebase

class NewsDetailsImageCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsDetailsImageCell"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentImage: UIImageView!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(url: String) {
        let storage = Storage.storage().reference(forURL: url)
        contentImage.sd_setImage(with: storage)
    }
}
