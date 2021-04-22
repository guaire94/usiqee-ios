//
//  AllArtistVC.swift
//  Usiqee
//
//  Created by Amine on 18/04/2021.
//

import UIKit

protocol AllArtistVCDelegate: AnyObject {
    func didFinishLoadingArtists()
    func didSelect(artist: ArtistBandBase)
}

class AllArtistVC: UIViewController {

    enum Constants {
        fileprivate static let collectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    // MARK: - IBOutlet
    @IBOutlet private weak var artistsLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    private var allArtists: [ArtistBandBase] = []
    private var filtredArtists: [ArtistBandBase] = []
    private var indexTitles: [String]?
    
    private weak var delegate: AllArtistVCDelegate?
    private weak var dataSource: ArtistVCDataSource?
    
    init(dataSource: ArtistVCDataSource?, delegate: AllArtistVCDelegate?) {
        super.init(nibName: "AllArtistVC", bundle: nil)
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        loadItems()
    }
    
    func refresh() {
        defer {
            reload()
        }
        
        guard let text = dataSource?.filterBy()?.uppercased(), !text.isEmpty else {
            filtredArtists = allArtists
            return
        }
        
        filtredArtists = allArtists.filter({ item -> Bool in
            item.name.uppercased().contains(text)
        })
    }

    // MARK: - Privates
    private func setupView() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        setupArtistsCollectionView()
        artistsLabel.text = L10N.Artist.allArtist.title
        artistsLabel.font = Fonts.AllArtist.title
    }
    
    private func setupArtistsCollectionView() {
        collectionView.register(ArtistListCell.Constants.nib, forCellWithReuseIdentifier: ArtistListCell.Constants.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func loadItems() {
        ServiceArtist.getArtists { artists in
            self.allArtists = artists
            
            self.allArtists.sort { lItem, rItem -> Bool in
                lItem.name < rItem.name
            }
            self.filtredArtists = self.allArtists
            self.reload()
            self.delegate?.didFinishLoadingArtists()
        }
    }
    
    private func reload() {
        indexTitles = Array(Set(filtredArtists.map{ String($0.name.prefix(1)).uppercased() })).sorted(by: { $0 < $1 })
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension AllArtistVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = filtredArtists.count
        
        if numberOfItems == 0 {
            collectionView.setEmptyMessage(L10N.Artist.allArtist.emptyListMessage)
        }else {
            collectionView.restore()
        }
        
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistListCell.Constants.identifier, for: indexPath) as? ArtistListCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(item: filtredArtists[indexPath.row])
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
extension AllArtistVC: UICollectionViewDelegateFlowLayout {
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

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}
