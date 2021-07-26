//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class ArtistDetailsNewsCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 105
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "ArtistDetailsNewsCell"
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var newsCover: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleLabel.font = Fonts.News.Cell.title
        dateLabel.font = Fonts.News.Cell.date
    }

    func configure(likedNews: RelatedNews) {
        let coverStorage = Storage.storage().reference(forURL: likedNews.cover)
        newsCover.sd_setImage(with: coverStorage)

        titleLabel.text = likedNews.title
        titleLabel.text = likedNews.title
        dateLabel.text = likedNews.date.dateValue().short
    }
}
