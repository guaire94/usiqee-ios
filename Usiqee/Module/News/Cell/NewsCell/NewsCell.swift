//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class NewsCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 105
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsCell"
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var newsCover: UIImageView!
    @IBOutlet weak private var authorView: UIStackView!
    @IBOutlet weak private var authorAvatar: UIImageView!
    @IBOutlet weak private var authorLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        authorView.isHidden = true
        titleLabel.font = Fonts.News.Cell.title
        authorLabel.font = Fonts.News.Cell.author
        dateLabel.font = Fonts.News.Cell.date
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        authorAvatar.sd_cancelCurrentImageLoad()
        authorAvatar.image = nil
        authorView.isHidden = true
    }

    func configure(item: NewsItem) {
        let coverStorage = Storage.storage().reference(forURL: item.news.cover)
        newsCover.sd_setImage(with: coverStorage)

        titleLabel.text = item.news.title
        titleLabel.text = item.news.title
        dateLabel.text = item.news.date.dateValue().short

        guard let author = item.author else { return }
        authorView.isHidden = false
        let authorStorage = Storage.storage().reference(forURL: author.avatar)
        authorAvatar.sd_setImage(with: authorStorage)
        authorLabel.text = author.name
    }
}
