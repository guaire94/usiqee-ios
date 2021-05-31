//
//  CommentCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 15/03/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit
import Firebase

class EventCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 118
        static let identifier: String = "EventCell"
    }
    
    // MARK: - IBOutlet

    // MARK: - Properties
    var event: Event?

    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setUp(event: Event) {
        setUpDisplay()
        self.event = event
    }
    
    // MARK: - Private
    private func setUpDisplay() {
        selectionStyle = .none
    }
}
