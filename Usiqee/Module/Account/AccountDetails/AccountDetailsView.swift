//
//  AccountDetailsView.swift
//  Usiqee
//
//  Created by Amine on 04/05/2021.
//

import UIKit
import Kingfisher

protocol AccountDetailsViewDelegate: class {
    func didTapSettings()
}

class AccountDetailsView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let identifier = "AccountDetailsView"
        fileprivate static let placeHolderImage: UIImage = #imageLiteral(resourceName: "userPlaceholder")
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var segmentedMenu: MSegmentedMenu!
    @IBOutlet weak private var userName: UILabel!
    @IBOutlet weak private var userAvatar: CircularImageView!
    
    weak var delegate: AccountDetailsViewDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func refresh() {
        ManagerAuth.shared.synchronise {
            self.displayUserInformation()
        }
    }
    
    // MARK: - Private
    private func commonInit() {
        loadView()
        setupView()
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed(Constants.identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
        
    private func setupView() {
        displayUserInformation()
        userName.font = Fonts.AccountDetails.userName
        segmentedMenu.delegate = self
    }
    
    private func displayUserInformation() {
        guard let user = ManagerAuth.shared.user else {
            return
        }
        
        segmentedMenu.configure(with: L10N.UserDetails.Menu.followed(10), L10N.UserDetails.Menu.favoris(16))
        userName.text = user.username
        
        userAvatar.image = Constants.placeHolderImage
        if let url = URL(string: user.avatar) {
            userAvatar.kf.setImage(with: url)
        }
    }
}

// MARK: - MSegmentedMenuDelegate
extension AccountDetailsView: MSegmentedMenuDelegate {
    func didSelectItem(at index: Int) {
        
    }
}

// MARK: - IBActions
extension AccountDetailsView {
    @IBAction func onSettingsTapped(_ sender: Any) {
        delegate?.didTapSettings()
    }
}
