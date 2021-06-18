//
//  ArtistDetailsGroupesCell.swift
//  Usiqee
//
//  Created by Amine on 16/06/2021.
//

import UIKit

class ArtistDetailsGroupesCell: UITableViewCell {

    // MARK: - Constants
    enum Constants {
        static let identifier = "ArtistDetailsGroupesCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let cornerRadius: CGFloat = 11
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var bands: [RelatedBand] = []
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configure(bands: [RelatedBand]) {
        self.bands = bands
        collectionView.reloadData()
    }
    
    // MARK: - Private
    private func setupUI() {
        titleLabel.text = L10N.ArtistDetails.Bio.Groupes.title
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
extension ArtistDetailsGroupesCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCollectionViewCell.Constants.identifier, for: indexPath) as? ArtistCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(relatedBand: bands[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ArtistDetailsGroupesCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightCell = collectionView.frame.height
        let widthCell = heightCell / 1.4
        return CGSize(width: widthCell, height: heightCell)
    }
}
