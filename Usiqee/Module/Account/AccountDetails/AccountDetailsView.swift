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
    @IBOutlet weak private var menuContentTableView: UITableView!
    
    weak var delegate: AccountDetailsViewDelegate?
    
    private var musicalEntities: [RelatedMusicalEntity] = []
    
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
            self.retreiveFollowedMusicalEntities()
            self.displayUserInformation()
            self.menuContentTableView.reloadData()
        }
    }
    
    // MARK: - Private
    private func commonInit() {
        loadView()
        setupView()
        setupTableView()
    }
    
    private func setupTableView() {
        menuContentTableView.register(AccountDetailsFollowingCell.Constants.nib, forCellReuseIdentifier: AccountDetailsFollowingCell.Constants.identifier)
        menuContentTableView.dataSource = self
        menuContentTableView.delegate = self
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
        
        displayMenuItems()
        userName.text = user.username
        
        userAvatar.image = Constants.placeHolderImage
        if let url = URL(string: user.avatar) {
            userAvatar.kf.setImage(with: url)
        }
    }
    
    private func displayMenuItems() {
        segmentedMenu.configure(with: L10N.UserDetails.Menu.followed(musicalEntities.count), L10N.UserDetails.Menu.favoris(16))
    }
    
    private func retreiveFollowedMusicalEntities() {
        let artists = ManagerAuth.shared.followedArtists
        let bands = ManagerAuth.shared.followedBands
        
        musicalEntities.removeAll()
        musicalEntities.append(contentsOf: artists)
        musicalEntities.append(contentsOf: bands)
        musicalEntities.sort(by: { $0.name < $1.name })
    }
    
    private func unfollow(artist: RelatedArtist) {
        guard let relatedArtist = ManagerAuth.shared.relatedArtist(by: artist.artistId) else {
            return
        }
        ServiceArtist.unfollow(artist: relatedArtist) { [weak self] error in
            self?.menuContentTableView.reloadData()
        }
    }
    
    private func unfollow(band: RelatedBand) {
        guard let relatedBand = ManagerAuth.shared.relatedBand(by: band.bandId) else {
            return
        }
        ServiceBand.unfollow(band: relatedBand) { [weak self] error in
            self?.menuContentTableView.reloadData()
        }
    }
}

// MARK: - MSegmentedMenuDelegate
extension AccountDetailsView: MSegmentedMenuDelegate {
    func didSelectItem(at index: Int) {
        menuContentTableView.reloadData()
    }
}

// MARK: - IBActions
extension AccountDetailsView {
    @IBAction func onSettingsTapped(_ sender: Any) {
        delegate?.didTapSettings()
    }
}

// MARK: - UITableViewDataSource
extension AccountDetailsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedMenu.selectedItem == 0 {
            let numberOfItems = musicalEntities.count
            if numberOfItems == 0 {
                tableView.setEmptyMessage(L10N.UserDetails.followedEmptyListMessage)
            }else {
                tableView.restore()
            }
            return numberOfItems
        }
        
        tableView.restore()
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedMenu.selectedItem == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailsFollowingCell.Constants.identifier) as? AccountDetailsFollowingCell else {
                return UITableViewCell()
            }
            cell.configure(musicalEntity: musicalEntities[indexPath.row])
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension AccountDetailsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segmentedMenu.selectedItem == 0 {
            return AccountDetailsFollowingCell.Constants.height
        }
        
        return 0
    }
}

// MARK: - AccountDetailsFollowingCellDelegate
extension AccountDetailsView: AccountDetailsFollowingCellDelegate {
    func didTapUnfollow(cell: AccountDetailsFollowingCell) {
        guard let indexPath = menuContentTableView.indexPath(for: cell) else {
            return
        }
        let muscialEntity = musicalEntities[indexPath.row]
        
        if let artist = muscialEntity as? RelatedArtist {
            unfollow(artist: artist)
            return
        }
        
        if let band = muscialEntity as? RelatedBand {
            unfollow(band: band)
            return
        }
    }
}
