//
//  ArtistDetailsLabelsCell.swift
//  Usiqee
//
//  Created by Amine on 17/06/2021.
//

import UIKit

class ArtistDetailsLabelsCell: UITableViewCell {

    // MARK: - Constants
    enum Constants {
        static let identifier = "ArtistDetailsLabelsCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let cornerRadius: CGFloat = 11
        fileprivate static let cellWitdhPercentage: CGFloat = 1.1
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var labels: [RelatedLabel] = []
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configure(labels: [RelatedLabel]) {
        self.labels = labels
        collectionView.reloadData()
    }
    
    // MARK: - Private
    private func setupUI() {
        titleLabel.text = L10N.ArtistDetails.Bio.Labels.title
        titleLabel.font = Fonts.ArtistDetails.Bio.title
        containerView.layer.cornerRadius = Constants.cornerRadius
        setupArtistsCollectionView()
    }
    
    private func setupArtistsCollectionView() {
        collectionView.register(ArtistDetailsLabelCell.Constants.nib, forCellWithReuseIdentifier: ArtistDetailsLabelCell.Constants.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension ArtistDetailsLabelsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistDetailsLabelCell.Constants.identifier, for: indexPath) as? ArtistDetailsLabelCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(label: labels[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ArtistDetailsLabelsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightCell = collectionView.frame.height
        let widthCell = heightCell / Constants.cellWitdhPercentage
        return CGSize(width: widthCell, height: heightCell)
    }
}
