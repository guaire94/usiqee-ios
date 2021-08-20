//
//  NewsDetailsTextCell.swift
//  Usiqee
//
//  Created by Amine on 06/07/2021.
//

import UIKit

protocol NewsDetailsTextCellDelegate {
    func linkToggle(url: URL)
}

class NewsDetailsTextCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsDetailsTextCell"
        fileprivate static let kern: CGFloat = -0.33
        fileprivate static let lineHeightMultiple: CGFloat = 1.11
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentTextView: UITextView!
    
    
    // MARK: - Privates
    var delegate: NewsDetailsTextCellDelegate?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(content: String) {
        contentTextView.delegate = self
        if let data = content.data(using: .utf8),
           let html = try? NSMutableAttributedString(data: data,
                                                     options: [.documentType: NSAttributedString.DocumentType.html],
                                                     documentAttributes: nil) {
            let range = NSMakeRange(0, html.length)
            html.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: range)
            contentTextView.attributedText = html
        } else {
            contentTextView.text = content
        }
        contentTextView.translatesAutoresizingMaskIntoConstraints = true
        contentTextView.sizeToFit()
        contentTextView.isScrollEnabled = false
     }
}

extension NewsDetailsTextCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        delegate?.linkToggle(url: URL)
        return false
    }
    
}

private struct FormattedItem {
    let text: String
    let url: URL
    let range: NSRange
}
