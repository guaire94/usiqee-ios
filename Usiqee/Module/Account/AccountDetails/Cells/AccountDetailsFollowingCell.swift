//
//  AccountDetailsFollowingCell.swift
//  Usiqee
//
//  Created by Amine on 13/05/2021.
//

import UIKit
import Firebase

protocol AccountDetailsFollowingCellDelegate: class {
    func didTapUnfollow(cell: AccountDetailsFollowingCell)
}

class AccountDetailsFollowingCell: UITableViewCell {

    // MARK: - Constants
    enum Constants {
        static let identifier: String = "AccountDetailsFollowingCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        static let height: CGFloat = 80
    }
    
    // MARK: - Properties
    weak var delegate: AccountDetailsFollowingCellDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet private weak var avatarImage: CircularImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var unfollowButton: FilledButton!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        unfollowButton.setTitle(L10N.UserDetails.unfollow, for: .normal)
        unfollowButton.layer.cornerRadius = 15
        nameLabel.font = Fonts.AccountDetails.artistName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImage.image = nil
        unfollowButton.loadingIndicator(show: false)
    }
    
    func configure(musicalEntity: RelatedMusicalEntity) {
        nameLabel.text = musicalEntity.name
        
        let storage = Storage.storage().reference(forURL: musicalEntity.avatar)
        avatarImage.sd_setImage(with: storage)
    }
}

// MARK: - AccountDetailsFollowingCell
extension AccountDetailsFollowingCell {
    @IBAction func onUnfollowTapped(_ sender: Any) {
        unfollowButton.loadingIndicator(show: true)
        delegate?.didTapUnfollow(cell: self)
    }
}
