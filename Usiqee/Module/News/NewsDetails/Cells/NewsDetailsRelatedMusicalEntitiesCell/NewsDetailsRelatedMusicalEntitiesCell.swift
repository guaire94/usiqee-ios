//
//  NewsDetailsRelatedMusicalEntitiesCell.swift
//  Usiqee
//
//  Created by Amine on 18/08/2021.
//

import UIKit

protocol NewsDetailsRelatedMusicalEntitiesCellDelegate: AnyObject {
    func didSelect(musicalEntity: RelatedMusicalEntity)
}

class NewsDetailsRelatedMusicalEntitiesCell: UITableViewCell {

    // MARK: - Constant
    enum Constants {
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsDetailsRelatedMusicalEntitiesCell"
        fileprivate static let widthRatio: CGFloat = 1.28
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var musicalEntities: [RelatedMusicalEntity] = []
    private var delegate: NewsDetailsRelatedMusicalEntitiesCellDelegate?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTitle()
        setupCollectionView()
    }

    func configure(musicalEntity: [RelatedMusicalEntity], delegate: NewsDetailsRelatedMusicalEntitiesCellDelegate?) {
        self.delegate = delegate
        self.musicalEntities = musicalEntity
        collectionView.reloadData()
    }
    
    // MARK: - private
    private func setupTitle() {
        titleLabel.font = Fonts.NewsDetails.RelatedMusicalEntity.title
        titleLabel.text = L10N.NewsDetails.RelatedMusicalEntityTitle
    }
    
    private func setupCollectionView() {
        collectionView.register(NewsDetailsRelatedMusicalEntityCell.Constants.nib, forCellWithReuseIdentifier: NewsDetailsRelatedMusicalEntityCell.Constants.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension NewsDetailsRelatedMusicalEntitiesCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        musicalEntities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsDetailsRelatedMusicalEntityCell.Constants.identifier, for: indexPath) as? NewsDetailsRelatedMusicalEntityCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(musicalEntity: musicalEntities[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NewsDetailsRelatedMusicalEntitiesCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightCell = collectionView.frame.height
        let widthCell = heightCell / Constants.widthRatio
        return CGSize(width: widthCell, height: heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(musicalEntity: musicalEntities[indexPath.row])
    }
}
