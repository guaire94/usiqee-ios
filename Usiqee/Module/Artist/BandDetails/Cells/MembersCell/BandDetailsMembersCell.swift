//
//  BandDetailsMembersCell.swift
//  Usiqee
//
//  Created by Amine on 17/06/2021.
//

import UIKit

protocol BandDetailsMembersCellDelegate: AnyObject {
    func didSelect(artist: RelatedArtist)
}

class BandDetailsMembersCell: UITableViewCell {

    // MARK: - Constants
    enum Constants {
        static let identifier = "BandDetailsMembersCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let cornerRadius: CGFloat = 11
        fileprivate static let cellWitdhPercentage: CGFloat = 1.4
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var artists: [RelatedArtist] = []
    private weak var delegate: BandDetailsMembersCellDelegate?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configure(artists: [RelatedArtist], delegate: BandDetailsMembersCellDelegate?) {
        self.artists = artists
        self.delegate = delegate
        collectionView.reloadData()
    }
    
    // MARK: - Private
    private func setupUI() {
        titleLabel.text = L10N.ArtistDetails.Bio.Members.title
        titleLabel.font = Fonts.ArtistDetails.Bio.title
        containerView.layer.cornerRadius = Constants.cornerRadius
        setupArtistsCollectionView()
    }
    
    private func setupArtistsCollectionView() {
        collectionView.register(ArtistCollectionViewCell.Constants.nib, forCellWithReuseIdentifier: ArtistCollectionViewCell.Constants.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension BandDetailsMembersCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCollectionViewCell.Constants.identifier, for: indexPath) as? ArtistCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(relatedArtist: artists[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BandDetailsMembersCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightCell = collectionView.frame.height
        let widthCell = heightCell / Constants.cellWitdhPercentage
        return CGSize(width: widthCell, height: heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(artist: artists[indexPath.row])
    }
}
