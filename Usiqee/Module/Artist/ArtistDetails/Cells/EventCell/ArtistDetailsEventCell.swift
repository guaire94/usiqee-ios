//
//  ArtistDetailsEventCell.swift
//  Usiqee
//
//  Created by Amine on 26/05/2021.
//

import UIKit

class ArtistDetailsEventCell: UITableViewCell {

    // MARK: - Constant
    enum Constants {
        static let identifier = "ArtistDetailsEventCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var eventDate: UILabel!
    @IBOutlet weak private var eventType: UILabel!
    @IBOutlet weak private var eventDescription: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configure(event: RelatedEvent) {
        eventDescription.text = event.title
        eventType.text = event.eventType?.title
        eventDate.text = event.date.short
    }
    
    // MARK: - Private
    private func setupView() {
        selectionStyle = .none
        eventDate.font = Fonts.ArtistDetails.Events.date
        eventType.font = Fonts.ArtistDetails.Events.type
        eventDescription.font = Fonts.ArtistDetails.Events.description
    }
}
