//
//  NewsDetailsFooterView.swift
//  Usiqee
//
//  Created by Amine on 08/07/2021.
//

import UIKit

protocol NewsDetailsFooterViewDelegate: AnyObject {
    func didTapShare()
    func didTapLike()
}

class NewsDetailsFooterView: UIView {
    
    // MARK: - IBOulet
    @IBOutlet weak private var shareButton: UIButton!
    @IBOutlet weak private var likeButton: UIButton!

    // MARK: - Properties
    private weak var delegate: NewsDetailsFooterViewDelegate?
    private var news: News?

    // MARK: - LifeCycle
    func configure(news: News, delegate: NewsDetailsFooterViewDelegate?) {
        self.news = news
        self.delegate = delegate
        setUpShareButton()
        setUpLikeButton()
    }
    
    func setUpLikeButton() {
        guard let news = news else { return }
        
        if ManagerAuth.shared.isLiked(news: news) {
            likeButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
            // TODO: update like button picture with fil heart
        } else {
            likeButton.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
        }
    }

    // MARK: - Private
    private func setUpShareButton() {
        guard news?.externalLink != nil else {
            shareButton.isHidden = true
            return
        }
        shareButton.isHidden = false
    }
}

// MARK: - IBActions
extension NewsDetailsFooterView {
    @IBAction func onShareTapped(_ sender: Any) {
        delegate?.didTapShare()
    }
    
    @IBAction func onLikeTapped(_ sender: Any) {
        delegate?.didTapLike()
    }
}
