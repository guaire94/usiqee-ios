//
//  AgendaVC.swift
//  Usiqee
//
//  Created by Quentin Gallois on 10/11/2020.
//

import UIKit
import Firebase

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

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    // MARK: - Privates
    private func setUpView() {
    }
}

// MARK: - IBAction
extension ArtistVC {
    
    @IBAction func searchButtonToggle(_ sender: Any) {
    }
}
