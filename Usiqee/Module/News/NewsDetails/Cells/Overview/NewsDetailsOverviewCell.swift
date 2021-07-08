//
//  NewsDetailsOverviewCell.swift
//  Usiqee
//
//  Created by Amine on 06/07/2021.
//

import UIKit

import UIKit
import Firebase

class NewsDetailsOverviewCell: UITableViewCell {
    
    //MARK: - Constant
    enum Constants {
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsDetailsOverviewCell"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var newsCover: UIImageView!
    @IBOutlet weak private var authorView: UIStackView!
    @IBOutlet weak private var authorAvatar: UIImageView!
    @IBOutlet weak private var authorLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        authorView.isHidden = true
        authorLabel.font = Fonts.NewsDetails.Overview.author
        titleLabel.font = Fonts.NewsDetails.Overview.title
        dateLabel.font = Fonts.NewsDetails.Overview.date
        timeLabel.font = Fonts.NewsDetails.Overview.hour
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
        timeLabel.text = item.news.date.dateValue().hour
        
        guard let author = item.author else { return }
        authorView.isHidden = false
        let authorStorage = Storage.storage().reference(forURL: author.avatar)
        authorAvatar.sd_setImage(with: authorStorage)
        authorLabel.text = author.name
    }
}
