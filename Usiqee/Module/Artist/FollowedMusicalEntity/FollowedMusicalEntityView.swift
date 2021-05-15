//
//  FollowedMusicalEntityView.swift
//  Usiqee
//
//  Created by Amine on 12/05/2021.
//

import UIKit
import FirebaseFirestoreSwift

protocol FollowedMusicalEntityViewDelegate: AnyObject {
    func didSelectArtist(id: String)
    func didSelectBand(id: String)
}

class FollowedMusicalEntityView: UIView {

    enum Constants {
        static let identifier: String = "FollowedMusicalEntityView"
    }
    
    // MARK: - IBOutlet
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var followingNumberLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    private var musicalEntities: [RelatedMusicalEntity] = []
    private var filtredMusicalEntities: [RelatedMusicalEntity] = []
    weak var delegate: FollowedMusicalEntityViewDelegate?
    weak var dataSource: ArtistVCDataSource?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Public
    func refresh() {
        defer {
            collectionView.reloadData()
        }
        loadItems()
        
        if musicalEntities.isEmpty {
            isHidden = true
            return
        }
        isHidden = false
        
        guard let text = dataSource?.filterBy?.uppercased(), !text.isEmpty else {
            filtredMusicalEntities = musicalEntities
            return
        }
        
        filtredMusicalEntities = musicalEntities.filter({ item -> Bool in
            item.name.uppercased().contains(text)
        })
    }
    
    // MARK: - Private
    private func commonInit() {
        loadView()
        setupView()
        refresh()
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed(Constants.identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupView() {
        setupArtistsCollectionView()
        titleLabel.text = L10N.Artist.FollowedArtist.title
        titleLabel.font = Fonts.FollowedArtist.title
        followingNumberLabel.font = Fonts.FollowedArtist.numberOfFollowing
    }
    
    private func setupArtistsCollectionView() {
        collectionView.register(ArtistCollectionViewCell.Constants.nib, forCellWithReuseIdentifier: ArtistCollectionViewCell.Constants.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func loadItems() {
        let artists = ManagerAuth.shared.followedArtists
        let bands = ManagerAuth.shared.followedBands
        
        musicalEntities.removeAll()
        musicalEntities.append(contentsOf: artists)
        musicalEntities.append(contentsOf: bands)
        musicalEntities.sort(by: { $0.name < $1.name })
        followingNumberLabel.text = "\(musicalEntities.count)"
    }
}

// MARK: - UICollectionViewDataSource
extension FollowedMusicalEntityView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = filtredMusicalEntities.count
        
        if numberOfItems == 0 {
            collectionView.setEmptyMessage(L10N.Artist.allArtist.emptyListMessage)
        }else {
            collectionView.restore()
        }
        
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCollectionViewCell.Constants.identifier, for: indexPath) as? ArtistCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(followedEntity: filtredMusicalEntities[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FollowedMusicalEntityView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightCell = collectionView.frame.height
        let widthCell = heightCell / 1.5
        return CGSize(width: widthCell, height: heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let artist = filtredMusicalEntities[indexPath.row] as? RelatedArtist {
            delegate?.didSelectArtist(id: artist.artistId)
            return
        }
        
        if let band = filtredMusicalEntities[indexPath.row] as? RelatedBand {
            delegate?.didSelectBand(id: band.bandId)
            return
        }
    }
}
