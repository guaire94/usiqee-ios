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
        fileprivate enum externalLinkButton {
            static let width: CGFloat = 35
            static let height: CGFloat = 35
            static let tintColor: UIColor = .white
            static let imageEdgeInsetTop: CGFloat = 8
            static let imageEdgeInsetBottom: CGFloat = 8
            static let imageEdgeInsetRight: CGFloat = 8
            static let imageEdgeInsetLeft: CGFloat = 8
        }
    }
        
    // MARK: - IBOutlets
    @IBOutlet weak private var authorAvatar: CircularImageView!
    @IBOutlet weak private var authorLabel: UILabel!
    @IBOutlet weak private var externalLinkButton: FilledButton!
    @IBOutlet weak private var externalLinkView: UIView!
    @IBOutlet weak private var authorDescriptionLabel: UILabel!
    @IBOutlet weak private var authorLinksStack: UIStackView!
    @IBOutlet weak private var authorLinksView: UIView!
    
    // MARK: - Properties
    private weak var delegate: NewsDetailsAuthorCellDelegate?
    private var author: Author?
    private var externalLink: String?
    
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

    func configure(author: Author, externalLink: String?, delegate: NewsDetailsAuthorCellDelegate?) {
        self.delegate = delegate
        self.author = author
        self.externalLink = externalLink
        authorDescriptionLabel.text = author.desc
        authorLabel.text = author.name
        let authorStorage = Storage.storage().reference(forURL: author.avatar)
        authorAvatar.sd_setImage(with: authorStorage)

        if let externalLink = externalLink,
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
            let button = createExternalLinkButton(with: externalLink)
            authorLinksStack.addArrangedSubview(button)
        }
    }
    
    private func createExternalLinkButton(with socialMedia: Author.SocialMedia) -> UIButton{
        let button = UIButton()
        button.tintColor = Constants.externalLinkButton.tintColor
        button.imageEdgeInsets = UIEdgeInsets(
            top: Constants.externalLinkButton.imageEdgeInsetTop,
            left: Constants.externalLinkButton.imageEdgeInsetLeft,
            bottom: Constants.externalLinkButton.imageEdgeInsetBottom,
            right: Constants.externalLinkButton.imageEdgeInsetRight
        )
        button.widthAnchor.constraint(equalToConstant: Constants.externalLinkButton.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: Constants.externalLinkButton.height).isActive = true
        button.addTarget(self, action: #selector(onSocialMediaTapped(_:)), for: .touchUpInside)
        button.setImage(socialMedia.image, for: .normal)
        button.tag = socialMedia.rawValue
        return button
    }
}

// MARK: - IBActions & selector
private extension NewsDetailsAuthorCell {
    @IBAction func onExternalLinkTapped() {
        delegate?.showExternalLink(url: externalLink)
    }
    
    @objc
    func onSocialMediaTapped(_ sender: UIButton) {
        guard let item = Author.SocialMedia(rawValue: sender.tag),
              let url = author?.externalLink(for: item) else { return }
        
        delegate?.openExternalLink(url: url)
    }
}
