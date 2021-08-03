//
//  EventDetailsOverviewCell.swift
//  Usiqee
//
//  Created by Amine on 29/07/2021.
//

import UIKit
import Firebase

class EventDetailsOverviewCell: UITableViewCell {

    // MARK: - Constants
    enum Constants {
        static let identifier: String = "EventDetailsOverviewCell"
        static let nib: UINib = UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - @IBOutlet
    @IBOutlet weak private var eventImage: UIImageView!
    @IBOutlet weak private var eventNameLabel: UILabel!
    @IBOutlet weak private var typeLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configure(information: EventDetailsOverview) {
        descriptionLabel.text = information.description.uppercased()
        typeLabel.text = information.type.title.uppercased()
        eventNameLabel.text = information.title?.uppercased()
        
        guard let avatar = information.avatar else { return }
        let storage = Storage.storage().reference(forURL: avatar)
        eventImage.sd_setImage(with: storage)
    }

    // MARK: - Private
    private func setupView() {
        eventNameLabel.font = Fonts.EventDetails.name
        descriptionLabel.font = Fonts.EventDetails.description
        typeLabel.font = Fonts.EventDetails.type
    }
}
