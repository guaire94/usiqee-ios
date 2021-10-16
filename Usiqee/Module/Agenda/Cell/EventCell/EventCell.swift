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
    @IBOutlet weak private var loading: UIActivityIndicatorView!

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
        descriptionLabel.text = item.event.title.uppercased()
        typeLabel.text = item.event.eventType?.title.uppercased()
        timeLabel.text = item.event.date.dateValue().hour
        
        if [.festival, .special].contains(item.event.eventType) {
            set(avatar: item.event.cover)
            set(title: item.event.planner)
        } else if let musicalEntity = item.musicalEntity {
            set(avatar: musicalEntity.avatar)
            set(title: musicalEntity.name)
        }
    }
    
    // MARK: - Private
    private func setupFonts() {
        artistLabel.font = Fonts.Events.Cell.name
        descriptionLabel.font = Fonts.Events.Cell.description
        typeLabel.font = Fonts.Events.Cell.type
        timeLabel.font = Fonts.Events.Cell.time
    }
    
    private func set(title: String?) {
        guard let title = title else { return }
        artistLabel.text = title.uppercased()
    }
    
    private func set(avatar: String?) {
        guard let avatar = avatar else { return }
        let storage = Storage.storage().reference(forURL: avatar)
        loading.startAnimating()
        avatarImage.sd_setImage(with: storage, placeholderImage: nil) { [weak self] _, _, _, _ in
            self?.loading.stopAnimating()
        }
    }
}
