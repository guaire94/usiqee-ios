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
    @IBOutlet weak private var allArtistView: AllMusicalEntityView!
    @IBOutlet weak private var followedArtistView: FollowedMusicalEntityView!
    
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
        loadingView.isHidden = false
        setupSearchTextField()
        loadAllArtistView()
        loadFollowedView()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        ManagerAuth.shared.add(delegate: self)
    }
    
    private func loadAllArtistView() {
        allArtistView.dataSource = self
        allArtistView.delegate = self
    }
    
    private func loadFollowedView() {
        followedArtistView.dataSource = self
        followedArtistView.delegate = self
    }

    private func setupSearchTextField() {
        searchTextField.delegate = self
        searchContainer.clipsToBounds = true
        searchContainer.layer.cornerRadius = Constants.searchPlaceholderCornerRadius
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: L10N.Artist.searchPlaceholder,
            attributes: [
                .foregroundColor: Constants.searchPlaceholderColor,
                .font: Fonts.AllArtist.search
            ]
        )
        searchTextField.font = Fonts.AllArtist.search
        searchTextField.clearButtonMode = .always
        searchTextField.setClearButton(tintColor: Constants.searchPlaceholderColor)
    }
    
    private func refreshView() {
        allArtistView.refresh()
        followedArtistView.refresh()
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

// MARK: - AllMusicalEntityViewDelegate
extension ArtistVC: AllMusicalEntityViewDelegate {
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

// MARK: - ManagerAuthSignInDelegate
extension ArtistVC: ManagerAuthDelegate {
    func didUpdateUserStatus() {
        followedArtistView.isHidden = !ManagerAuth.shared.isConnected
    }
    
    func didUpdateFollowedEntities() {
        followedArtistView.refresh()
    }
}

// MARK: - FollowedMusicalEntityViewDelegate
extension ArtistVC: FollowedMusicalEntityViewDelegate {
    func didSelectArtist(id: String) {
        let artist = ManagerMusicalEntity.shared.getArtist(by: id)
        performSegue(withIdentifier: ArtistDetailsVC.Constants.identifer, sender: artist)
    }
    
    func didSelectBand(id: String) {
        let band = ManagerMusicalEntity.shared.getBand(by: id)
        performSegue(withIdentifier: ArtistDetailsVC.Constants.identifer, sender: band)
    }
}
