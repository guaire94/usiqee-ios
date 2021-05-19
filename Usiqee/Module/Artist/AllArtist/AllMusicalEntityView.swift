//
//  AllMusicalEntityView.swift
//  Usiqee
//
//  Created by Amine on 18/04/2021.
//

import UIKit

protocol AllMusicalEntityViewDelegate: AnyObject {
    func didFinishLoadingArtists()
    func didSelect(artist: MusicalEntity)
}

class AllMusicalEntityView: UIView {

    enum Constants {
        static let identifier: String = "AllMusicalEntityView"
        fileprivate static let collectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    // MARK: - IBOutlet
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var artistsLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    private var allArtists: [MusicalEntity] = []
    private var filtredArtists: [MusicalEntity] = []
    private var indexTitles: [String]?
    
    weak var delegate: AllMusicalEntityViewDelegate?
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
            reload()
        }
        
        guard let text = dataSource?.filterBy?.uppercased(), !text.isEmpty else {
            filtredArtists = allArtists
            return
        }
        
        filtredArtists = allArtists.filter({ item -> Bool in
            item.name.uppercased().contains(text)
        })
    }
    
    // MARK: - Private
    private func commonInit() {
        loadView()
        setupView()
        ServiceArtist.listenArtists(delegate: self)
        ServiceBand.listenBands(delegate: self)
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed(Constants.identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupView() {
        setupArtistsCollectionView()
        artistsLabel.text = L10N.Artist.allArtist.title
        artistsLabel.font = Fonts.AllArtist.title
    }
    
    private func setupArtistsCollectionView() {
        collectionView.register(ArtistCollectionViewCell.Constants.nib, forCellWithReuseIdentifier: ArtistCollectionViewCell.Constants.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func didUpdateItems() {
        allArtists.sort(by: { $0.name < $1.name })
        filtredArtists = allArtists
        reload()
        delegate?.didFinishLoadingArtists()
    }
    
    private func reload() {
        indexTitles = Array(Set(filtredArtists.map{ String($0.name.prefix(1)).uppercased() })).sorted(by: { $0 < $1 })
        collectionView.reloadData()
    }
    
    private func handleItemIsAdded(musicalEntity: MusicalEntity) {
        allArtists.append(musicalEntity)
        didUpdateItems()
    }
    
    private func handleItemIsModified(musicalEntity: MusicalEntity) {
        guard let index = allArtists.firstIndex(where: { $0.id == musicalEntity.id }) else { return }
        allArtists[index] = musicalEntity
        didUpdateItems()
    }
    
    private func handleItemIsRemoved(musicalEntity: MusicalEntity) {
        guard let index = allArtists.firstIndex(where: { $0.id == musicalEntity.id }) else { return }
        allArtists.remove(at: index)
        didUpdateItems()
    }
}

// MARK: - UICollectionViewDataSource
extension AllMusicalEntityView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filtredArtists.isEmpty {
            collectionView.setEmptyMessage(L10N.Artist.allArtist.emptyListMessage)
        } else {
            collectionView.restore()
        }
        return filtredArtists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCollectionViewCell.Constants.identifier, for: indexPath) as? ArtistCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(artist: filtredArtists[indexPath.row])
        return cell
    }
    
    func indexTitles(for collectionView: UICollectionView) -> [String]? {
        indexTitles
    }
    
    func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        guard let index = filtredArtists.firstIndex(where: { $0.name.prefix(1) == title }) else {
            return IndexPath(item: 0, section: 0)
        }
        return IndexPath(item: index, section: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        Constants.collectionInset
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AllMusicalEntityView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nbCell = 3
        let nbSpacing = 10
        let fullWidth = collectionView.frame.width - (Constants.collectionInset.left + Constants.collectionInset.right)
        let widthCell = (fullWidth / CGFloat(nbCell)) - CGFloat(nbSpacing)
        let heightCell = widthCell * 1.28
        return CGSize(width: widthCell, height: heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(artist: filtredArtists[indexPath.row])
    }
}

//MARK: - ServiceArtistDelegate
extension AllMusicalEntityView: ServiceArtistDelegate {
    func dataAdded(artist: Artist) {
        handleItemIsAdded(musicalEntity: artist)
    }
    
    func dataModified(artist: Artist) {
        handleItemIsModified(musicalEntity: artist)
    }
    
    func dataRemoved(artist: Artist) {
        handleItemIsRemoved(musicalEntity: artist)
    }
}

//MARK: - ServiceBandDelegate
extension AllMusicalEntityView: ServiceBandDelegate {
    func dataAdded(band: Band) {
        handleItemIsAdded(musicalEntity: band)
    }
    
    func dataModified(band: Band) {
        handleItemIsModified(musicalEntity: band)
    }
    
    func dataRemoved(band: Band) {
        handleItemIsRemoved(musicalEntity: band)
    }
}
