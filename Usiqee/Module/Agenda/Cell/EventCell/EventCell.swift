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
    @IBOutlet weak private var artistLabel: UILabel!
    @IBOutlet weak private var typeLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var avatarImage: UIImageView!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupFonts()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImage.sd_cancelCurrentImageLoad()
        avatarImage.image = nil
    }
    
    func configure(item: EventItem) {
        descriptionLabel.text = item.event.title
        typeLabel.text = item.event.eventType?.title
        timeLabel.text = item.event.date.dateValue().time
        if let musicalEntity = item.musicalEntity {
            let storage = Storage.storage().reference(forURL: musicalEntity.avatar)
            avatarImage.sd_setImage(with: storage)
            artistLabel.text = musicalEntity.name
        }
    }
    
    // MARK: - Private
    private func setupFonts() {
        artistLabel.font = Fonts.Events.Cell.name
        descriptionLabel.font = Fonts.Events.Cell.description
        typeLabel.font = Fonts.Events.Cell.type
        timeLabel.font = Fonts.Events.Cell.time
    }
}
