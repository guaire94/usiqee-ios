//
//  EventsFilterEventTypeCell.swift
//  Usiqee
//
//  Created by Amine on 28/05/2021.
//

import UIKit

class EventsFilterEventTypeCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let identifier = "EventsFilterEventTypeCell"
        static let nib = UINib(nibName: identifier, bundle: nil)
        static let height: CGFloat = 50
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var eventTitle: UILabel!
    @IBOutlet weak private var isSelectedImage: UIImageView!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        eventTitle.font = Fonts.EventsFilter.Cell.title
    }
    
    func configure(event: SelectedEvent) {
        eventTitle.text = event.event.title
        isSelectedImage.isHidden = !event.isSelected
    }
}
