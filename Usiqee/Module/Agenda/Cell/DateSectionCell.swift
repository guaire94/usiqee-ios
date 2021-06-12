//
//  PlaylistSectionCell.swift
//  Mooddy
//
//  Created by Quentin Gallois on 14/01/2020.
//  Copyright © 2020 Quentin Gallois. All rights reserved.
//

import Firebase
import Foundation

class DateSectionCell: UITableViewHeaderFooterView {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "DateSectionCell"
        static let height: CGFloat = 48.0
        fileprivate static let dateFormat: String = "EEEE d"
    }
        
    // MARK: IBOutlet
    @IBOutlet weak private var dateLabel: UILabel!

    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.font = Fonts.Events.Cell.header
        backgroundView = UIView()
        backgroundView?.backgroundColor = .clear
    }
    
    func setup(date: Date) {
        dateLabel.text = date.stringWith(format: Constants.dateFormat)
    }
}
