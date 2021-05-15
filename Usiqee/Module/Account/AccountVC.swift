//
//  AgendaVC.swift
//  Usiqee
//
//  Created by Quentin Gallois on 10/11/2020.
//

import UIKit
import Firebase

class AccountVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "AccountVC"
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var accountDetailsView: AccountDetailsView!
    @IBOutlet weak private var notLoggedView: NotLoggedView!
    
    //MARK: - Properties

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        handleSubviewsVisibility()
        ManagerAuth.shared.add(delegate: self)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: - Privates
    private func setUpView() {
        notLoggedView.delegate = self
        accountDetailsView.delegate = self
    }
    
    private func handleSubviewsVisibility() {
        if ManagerAuth.shared.isConnected {
            accountDetailsView.refresh()
            accountDetailsView.isHidden = false
            notLoggedView.isHidden = true
        } else {
            accountDetailsView.isHidden = true
            notLoggedView.isHidden = false
        }
    }
}

// MARK: - NotLoggedViewDelegate
extension AccountVC: NotLoggedViewDelegate {
    func showPreAuthentication() {
        displayAuthentication()
    }
}

// MARK: - AccountDetailsViewDelegate
extension AccountVC: AccountDetailsViewDelegate {
    func didTapSettings() {
        performSegue(withIdentifier: AccountSettingsVC.Constants.identifier, sender: nil)
    }
}

// MARK: - ManagerAuthSignInDelegate
extension AccountVC: ManagerAuthDelegate {
    func didUpdateUserStatus() {
        handleSubviewsVisibility()
    }
    
    func didUpdateFollowedEntities() {
        accountDetailsView.refresh()
    }
}
