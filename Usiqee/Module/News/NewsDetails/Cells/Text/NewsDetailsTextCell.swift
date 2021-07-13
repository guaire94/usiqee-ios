//
//  NewsDetailsTextCell.swift
//  Usiqee
//
//  Created by Amine on 06/07/2021.
//

import UIKit

class NewsDetailsTextCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsDetailsTextCell"
        fileprivate static let kern: CGFloat = -0.33
        fileprivate static let lineHeightMultiple: CGFloat = 1.11
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.font = Fonts.NewsDetails.Text.content
    }
    
    func configure(content: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = Constants.lineHeightMultiple
        let attributedText = NSMutableAttributedString(
            string: content,
            attributes: [
                NSAttributedString.Key.kern: Constants.kern,
                NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        contentLabel.attributedText = attributedText
    }
}
