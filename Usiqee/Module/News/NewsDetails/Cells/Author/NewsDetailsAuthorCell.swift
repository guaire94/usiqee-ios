//
//  NewsDetailsAuthorCell.swift
//  Usiqee
//
//  Created by Amine on 06/07/2021.
//

import UIKit
import Firebase

protocol NewsDetailsAuthorCellDelegate: AnyObject {
    func showExternalLink(url: String?)
    func openExternalLink(url: String?)
}

class NewsDetailsAuthorCell: UITableViewCell {

    // MARK: - Constant
    enum Constants {
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsDetailsAuthorCell"
        fileprivate static let externalLinkCornerRadius: CGFloat = 15
    }
        
    // MARK: - IBOutlets
    @IBOutlet weak private var authorAvatar: UIImageView!
    @IBOutlet weak private var authorLabel: UILabel!
    @IBOutlet weak private var externalLinkButton: FilledButton!
    @IBOutlet weak private var externalLinkView: UIView!
    @IBOutlet weak private var authorDescriptionLabel: UILabel!
    @IBOutlet weak private var authorLinksStack: UIStackView!
    @IBOutlet weak private var authorLinksView: UIView!
    
    // MARK: - Properties
    private weak var delegate: NewsDetailsAuthorCellDelegate?
    private var author: Author?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        hideSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideSubviews()
    }

    func configure(author: Author, delegate: NewsDetailsAuthorCellDelegate?) {
        self.delegate = delegate
        self.author = author
        authorDescriptionLabel.text = author.desc
        authorLabel.text = author.name
        let authorStorage = Storage.storage().reference(forURL: author.avatar)
        authorAvatar.sd_setImage(with: authorStorage)
        
        if let externalLink = author.webLink,
           let url = URL(string: externalLink),
           UIApplication.shared.canOpenURL(url) {
            externalLinkView.isHidden = false
            externalLinkButton.setTitle(L10N.NewsDetails.authorWebLink(author.name), for: .normal)
        }
        
        if author.hasExternalLinks {
            authorLinksView.isHidden = false
            showExternalLinks(author: author)
        }
    }
    
    // MARK: - Private
    private func setupView() {
        authorLabel.font = Fonts.NewsDetails.Author.name
        authorDescriptionLabel.font = Fonts.NewsDetails.Author.description
        externalLinkButton?.titleLabel?.font = Fonts.NewsDetails.Author.externalLink
        externalLinkButton.layer.cornerRadius = Constants.externalLinkCornerRadius
    }
    
    private func hideSubviews() {
        externalLinkView.isHidden = true
        authorLinksView.isHidden = true
        authorLinksStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func showExternalLinks(author: Author) {
        author.externalLinks.forEach { externalLink in
            let button = UIButton()
            button.widthAnchor.constraint(equalToConstant: 35).isActive = true
            button.heightAnchor.constraint(equalToConstant: 35).isActive = true
            button.setImage(externalLink.image, for: .normal)
            button.addTarget(self, action: #selector(onSocialMediaTapped(_:)), for: .touchUpInside)
            button.tag = externalLink.rawValue
            authorLinksStack.addArrangedSubview(button)
        }
    }
}

// MARK: - IBActions & selector
private extension NewsDetailsAuthorCell {
    @IBAction func onExternalLinkTapped() {
        delegate?.showExternalLink(url: author?.webLink)
    }
    
    @objc
    func onSocialMediaTapped(_ sender: UIButton) {
        guard let item = Author.SocialMedia(rawValue: sender.tag) else { return }
        
        let url: String?
        switch item {
        case .twitter:
            url = author?.twitterLink
        case .facebook:
            url = author?.fbLink
        case .instagram:
            url = author?.instagramLink
        case .youtube:
            url = author?.youtubeLink
        case .snapchat:
            url = author?.snapchatLink
        case .twitch:
            url = author?.twitchLink
        case .tiktok:
            url = author?.tiktokLink
        case .linkedin:
            url = author?.linkedinLink
        }
        
        delegate?.openExternalLink(url: url)
    }
}
