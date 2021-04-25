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
        fileprivate static let searchPlaceholderColor = UIColor.white.withAlphaComponent(0.2)
        fileprivate static let searchPlaceholderCornerRadius: CGFloat = 15
    }

    // MARK: - IBOutlet
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet weak private var searchContainer: UIView!
    @IBOutlet weak private var contentStackView: UIStackView!
    @IBOutlet weak private var loadingView: UIView!
    
    //MARK: - Properties
    weak var allArtistView: AllArtistVC?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ArtistDetailsVC.Constants.identifer {
            guard let vc = segue.destination as? ArtistDetailsVC,
                  let item = sender as? MusicalEntity else { return }
            vc.musicalEntity = item
        }
    }

    // MARK: - Privates
    private func setupView() {
        setupSearchTextField()
        loadAllArtistView()
    }
    
    private func loadAllArtistView() {
        let allArtistView = AllArtistVC(dataSource: self, delegate: self)
        contentStackView.addArrangedSubview(allArtistView.view)
        addChild(allArtistView)
        allArtistView.didMove(toParent: self)
        self.allArtistView = allArtistView
    }

    private func setupSearchTextField() {
        searchTextField.delegate = self
        searchContainer.clipsToBounds = true
        searchContainer.layer.cornerRadius = Constants.searchPlaceholderCornerRadius
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: L10N.Artist.searchPlaceholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: Constants.searchPlaceholderColor
            ]
        )
    }
    
    private func refreshView() {
        allArtistView?.refresh()
    }
}

// MARK: - Selectors
extension ArtistVC {
    @objc private func textFieldDidChange() {
        refreshView()
    }
}

// MARK: - ArtistVCDataSource
extension ArtistVC: ArtistVCDataSource {
    var filterBy: String? {
        searchTextField.text
    }
}

// MARK: - AllArtistVCDelegate
extension ArtistVC: AllArtistVCDelegate {
    func didSelect(artist: MusicalEntity) {
        performSegue(withIdentifier: ArtistDetailsVC.Constants.identifer, sender: artist)
    }
    
    func didFinishLoadingArtists() {
        loadingView.isHidden = true
    }
}

// MARK: - UITextFieldDelegate
extension ArtistVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
