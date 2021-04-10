//
//  AgendaVC.swift
//  Usiqee
//
//  Created by Quentin Gallois on 10/11/2020.
//

import UIKit
import Firebase

struct ArtistListItem {
    var avatar: String
    var name: String
    var isBand: Bool
}

class ArtistVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "ArtistVC"
    }

    // MARK: - IBOutlet
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var artistsLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    private var allItems: [ArtistListItem] = []
    private var items: [ArtistListItem] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadItems()
        searchTextField.autocorrectionType = .no
        searchTextField.inputAssistantItem.accessibilityHint = "amine"
    }

    // MARK: - Privates
    private func setupView() {
        collectionView.register(ArtistListCell.Constants.nib, forCellWithReuseIdentifier: ArtistListCell.Constants.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.2)])
    }
    @objc
    private func textFieldDidChange() {
        guard let text = searchTextField.text?.uppercased(), !text.isEmpty else {
            items = allItems
            collectionView.reloadData()
            return
        }
        
        items = allItems.filter({ item -> Bool in
            item.name.uppercased().contains(text)
        })
        collectionView.reloadData()
    }
    
    private func loadItems() {
        let group = DispatchGroup()
        
        allItems.removeAll()
        group.enter()
        ServiceArtist.getArtists { artists in
            self.allItems.append(contentsOf: artists.map({
                ArtistListItem(avatar: $0.avatar, name: $0.name, isBand: false)
            }))
            group.leave()
        }
        
        group.enter()
        ServiceBand.getBands { bands in
            self.allItems.append(contentsOf: bands.map({
                ArtistListItem(avatar: $0.avatar, name: $0.name, isBand: true)
            }))
            group.leave()
        }
        
        group.wait()
        group.notify(queue: .main) {
            self.allItems.sort { lItem, rItem -> Bool in
                lItem.name < rItem.name
            }
            self.items = self.allItems
            self.collectionView.reloadData()
        }
    }
}

// MARK: - IBAction
extension ArtistVC {
    
    @IBAction func searchButtonToggle(_ sender: Any) {
    }
}

// MARK: - UICollectionViewDataSource
extension ArtistVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistListCell.Constants.identifier, for: indexPath) as? ArtistListCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(item: items[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ArtistVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nbCell = 3
        let nbSpacing = 10
        let widthCell = (collectionView.frame.width / CGFloat(nbCell)) - CGFloat(nbSpacing)
        let heightCell = widthCell * 1.28
        return CGSize(width: widthCell, height: heightCell)
    }
}
