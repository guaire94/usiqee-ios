//
//  NewsDetailsOverviewCell.swift
//  Usiqee
//
//  Created by Amine on 06/07/2021.
//

import UIKit
import Firebase

protocol NewsDetailsOverviewCellDelegate: AnyObject {
    func didTapAuthor()
}

class NewsDetailsOverviewCell: UITableViewCell {
    
    //MARK: - Constant
    enum Constants {
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsDetailsOverviewCell"
        enum Spacing {
            static let title: CGFloat = 12
            static let date: CGFloat = 30
            static let subtitle: CGFloat = 30
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var newsCover: UIImageView!
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var authorView: UIStackView!
    @IBOutlet weak private var authorAvatar: UIImageView!
    @IBOutlet weak private var authorLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    @IBOutlet weak private var dateStackView: UIStackView!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    
    // MARK: - Properties
    private weak var delegate: NewsDetailsOverviewCellDelegate?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        authorView.isHidden = true
        authorLabel.font = Fonts.NewsDetails.Overview.author
        titleLabel.font = Fonts.NewsDetails.Overview.title
        subtitleLabel.font = Fonts.NewsDetails.Overview.subtitle
        dateLabel.font = Fonts.NewsDetails.Overview.date
        timeLabel.font = Fonts.NewsDetails.Overview.hour
        addAuthorTapGesture()
    }
    
    private func addAuthorTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAuthor))
        authorView.addGestureRecognizer(tap)
        authorView.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorAvatar.sd_cancelCurrentImageLoad()
        authorAvatar.image = nil
        authorView.isHidden = true
    }
    
    func configure(item: NewsItem, delegate: NewsDetailsOverviewCellDelegate?) {
        self.delegate = delegate
        let coverStorage = Storage.storage().reference(forURL: item.news.cover)
        newsCover.sd_setImage(with: coverStorage)
        
        titleLabel.text = item.news.title

        stackView.setCustomSpacing(Constants.Spacing.date, after: titleLabel)
        dateLabel.text = L10N.NewsDetails.dateTime(item.news.date.dateValue().short)
        timeLabel.text = item.news.date.dateValue().hour

        addSubtitleIfNeeded(item: item)

        guard let author = item.author else { return }
        stackView.setCustomSpacing(Constants.Spacing.title, after: authorView)
        authorView.isHidden = false
        let authorStorage = Storage.storage().reference(forURL: author.avatar)
        authorAvatar.sd_setImage(with: authorStorage)
        authorAvatar.layer.cornerRadius = authorAvatar.frame.width/2
        authorLabel.text = author.name
    }
    
    private func addSubtitleIfNeeded(item: NewsItem) {
        if !item.news.subtitle.isEmpty {
            subtitleLabel.text = item.news.subtitle
            stackView.setCustomSpacing(Constants.Spacing.subtitle, after: dateStackView)
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }
    }
    
    @objc
    private func didTapAuthor() {
        delegate?.didTapAuthor()
    }
}
