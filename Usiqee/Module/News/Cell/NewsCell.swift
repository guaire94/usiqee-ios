//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class NewsCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let identifier = "NewsCell"
        static let height: CGFloat = 90.0
    }
    
    // MARK: - IBOutlet
    
    // MARK: - Variables
    var new: News?
    
    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        selectionStyle = .none
    }
    
    func setUp(new: News) {
        setUpDisplay()
        self.new = new
    }
    
    // MARK: - Private
    private func setUpDisplay() {
        selectionStyle = .none
    }
}
