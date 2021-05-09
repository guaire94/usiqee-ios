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
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AccountSettingsVC.Constants.identifier {
            guard let vc = segue.destination as? AccountSettingsVC else {
                return
            }
            
            vc.delegate = self
        }
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
        displayAuthentication(with: self)
    }
}

// MARK: - AccountDetailsViewDelegate
extension AccountVC: AccountDetailsViewDelegate {
    func didTapSettings() {
        performSegue(withIdentifier: AccountSettingsVC.Constants.identifier, sender: nil)
    }
}

// MARK: - PreAuthVCDelegate
extension AccountVC: PreAuthVCDelegate {
    func didSignIn() {
        handleSubviewsVisibility()
    }
}

// MARK: - AccountSettingsVCDelegate
extension AccountVC: AccountSettingsVCDelegate {
    func didLogout() {
        handleSubviewsVisibility()
    }
}
