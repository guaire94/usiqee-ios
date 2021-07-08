//
//  NewsDetailsFooterView.swift
//  Usiqee
//
//  Created by Amine on 08/07/2021.
//

import UIKit

protocol NewsDetailsFooterViewDelegate: AnyObject {
    func didTapShare()
}

class NewsDetailsFooterView: UIView {
    
    // MARK: - IBOulet
    @IBOutlet weak private var shareButton: UIButton!
    
    // MARK: - Properties
    private weak var delegate: NewsDetailsFooterViewDelegate?
    
    // MARK: - LifeCycle
    func configure(news: NewsItem, delegate: NewsDetailsFooterViewDelegate?) {
        self.delegate = delegate
        if news.news.externalLink == nil {
            shareButton.isHidden = true
        }
    }
}

// MARK: - IBActions
extension NewsDetailsFooterView {
    @IBAction func onShareTapped(_ sender: Any) {
        delegate?.didTapShare()
    }
}
