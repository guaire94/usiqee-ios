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
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.font = Fonts.NewsDetails.Text.content
    }
    
    func configure(content: String) {
        contentLabel.text = content
    }
}
