//
//  EventDetailsDateAndLocationCell.swift
//  Usiqee
//
//  Created by Amine on 29/07/2021.
//

import UIKit

class EventDetailsDateAndLocationCell: UITableViewCell {

    // MARK: - Constants
    enum Constants {
        static let identifier: String = "EventDetailsDateAndLocationCell"
        static let nib: UINib = UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - IBOutlet
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        locationLabel.isHidden = true
    }
    
    func configure(event: Event) {
        dateLabel.text = event.date.dateValue().full
        timeLabel.text = event.date.dateValue().hour
        guard let locationDescription = event.locationDescription else { return }
        locationLabel.text = locationDescription
        locationLabel.isHidden = false
    }

    // MARK: - Private
    private func setupView() {
        selectionStyle = .none
        dateLabel.font = Fonts.EventDetails.date
        timeLabel.font = Fonts.EventDetails.time
        locationLabel.font = Fonts.EventDetails.location
        locationLabel.isHidden = true
    }
}
