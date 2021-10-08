//
//  NewsCarouselItemCell.swift
//  Usiqee
//
//  Created by Amine on 30/06/2021.
//

import UIKit
import Firebase

class NewsCarouselItemCell: UICollectionViewCell {

    //MARK: - Constant
    enum Constants {
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsCarouselItemCell"
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var newsCover: UIImageView!
    @IBOutlet weak private var authorView: UIStackView!
    @IBOutlet weak private var authorAvatar: CircularImageView!
    @IBOutlet weak private var authorLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var loader: UIActivityIndicatorView!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        authorView.isHidden = true
        authorLabel.font = Fonts.News.Carousel.author
        titleLabel.font = Fonts.News.Carousel.title
        dateLabel.font = Fonts.News.Carousel.date
        timeLabel.font = Fonts.News.Carousel.hour
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        newsCover.sd_cancelCurrentImageLoad()
        newsCover.image = nil
        
        authorAvatar.sd_cancelCurrentImageLoad()
        authorAvatar.image = nil
        authorView.isHidden = true
    }

    func configure(item: NewsItem) {
        let coverStorage = Storage.storage().reference(forURL: item.news.cover)

        loader.startAnimating()
        newsCover.sd_setImage(with: coverStorage, placeholderImage: nil) { [weak self] _, _, _, _ in
            self?.loader.stopAnimating()
        }

        titleLabel.text = item.news.title
        titleLabel.text = item.news.title
        dateLabel.text = L10N.News.dateTimeAgo(item.news.date.dateValue().timeAgo)
        timeLabel.text = item.news.date.dateValue().hour

        guard let author = item.author else { return }
        authorView.isHidden = false
        let authorStorage = Storage.storage().reference(forURL: author.avatar)
        authorAvatar.sd_setImage(with: authorStorage)
        authorLabel.text = author.name
    }
}
