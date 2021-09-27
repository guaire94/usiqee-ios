//
//  EventDetailsMusicalEntitiesListCell.swift
//  Usiqee
//
//  Created by Amine on 30/07/2021.
//

import UIKit

protocol EventDetailsMusicalEntitiesListCellDelegate: AnyObject {
    func didSelect(musicalEntity: RelatedMusicalEntity)
}

class EventDetailsMusicalEntitiesListCell: UITableViewCell {

    // MARK: - Constants
    enum Constants {
        static let identifier: String = "EventDetailsMusicalEntitiesListCell"
        static let nib: UINib = UINib(nibName: identifier, bundle: nil)
        fileprivate static let collectionViewSpacing: Int = 14
        fileprivate static let collectionViewWidthRatio: CGFloat = 1.1
    }
    
    // MARK: - IBOutlet
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var musicalEntities: [RelatedMusicalEntity] = []
    private weak var delegate: EventDetailsMusicalEntitiesListCellDelegate?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        collectionView.register(EventDetailsMusicalEntityCell.Constants.nib, forCellWithReuseIdentifier: EventDetailsMusicalEntityCell.Constants.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configure(musicalEntities: [RelatedMusicalEntity], delegate: EventDetailsMusicalEntitiesListCellDelegate?) {
        self.delegate = delegate
        self.musicalEntities = musicalEntities
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension EventDetailsMusicalEntitiesListCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        musicalEntities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventDetailsMusicalEntityCell.Constants.identifier, for: indexPath) as? EventDetailsMusicalEntityCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(musicalEntity: musicalEntities[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EventDetailsMusicalEntitiesListCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let numberOfItems = musicalEntities.count
        let heightCell = collectionView.frame.height
        let widthCell = heightCell / Constants.collectionViewWidthRatio
        let totalWidth = widthCell * CGFloat(numberOfItems)
        let totalSpacingWidth = CGFloat(Constants.collectionViewSpacing * (numberOfItems - 1))
        var inset = (collectionView.frame.width - (totalWidth + totalSpacingWidth)) / 2
        inset = max(inset, .zero)
        return UIEdgeInsets(top: .zero, left: inset, bottom: .zero, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightCell = collectionView.frame.height
        let widthCell = heightCell / Constants.collectionViewWidthRatio
        return CGSize(width: widthCell, height: heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(musicalEntity: musicalEntities[indexPath.row])
    }
}
