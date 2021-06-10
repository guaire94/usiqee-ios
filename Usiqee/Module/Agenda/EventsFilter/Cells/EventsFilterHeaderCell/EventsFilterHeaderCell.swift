//
//  EventsFilterHeaderCell.swift
//  Usiqee
//
//  Created by Amine on 27/05/2021.
//

import UIKit

class EventsFilterHeaderCell: UITableViewHeaderFooterView {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "EventsFilterHeaderCell"
        static let nib = UINib(nibName: identifier, bundle: nil)
        static let height: CGFloat = 40
    }
    
    // MARK: IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!

    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundView = UIView()
        titleLabel.font = Fonts.EventsFilter.Cell.header
    }
    
    func set(title: String) {
        titleLabel.text = title
        backgroundView?.backgroundColor = title.isEmpty ? .clear : Colors.darkGray
    }
}
