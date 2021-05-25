//
//  AccountSettingsVC.swift
//  Usiqee
//
//  Created by Amine on 04/05/2021.
//

import UIKit
import SafariServices

protocol AccountSettingsVCDelegate: class {
    func didLogout()
}

class AccountSettingsVC: UIViewController {
    
    // MARK: - Constants
    enum Constants {
        static let identifier: String = "AccountSettingsVC"
        
        fileprivate enum Links {
            static let privacy: String = "https://www.google.fr"
            static let cgu: String = "https://www.apple.fr"
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var legalNoticeLabel: UILabel!
    @IBOutlet weak private var privacyButton: UIButton!
    @IBOutlet weak private var cguButton: UIButton!
    @IBOutlet weak private var logoutButton: FilledButton!
    @IBOutlet weak private var notificationsLabel: UILabel!
    @IBOutlet weak private var manageNotificationsButton: UIButton!
    
    weak var delegate: AccountSettingsVCDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private
    private func setupView() {
        setupTranslation()
        setupStyle()
    }
    
    private func setupTranslation() {
        titleLabel.text = L10N.AccountSettings.title
        legalNoticeLabel.text = L10N.AccountSettings.legalNotice.uppercased()
        privacyButton.setTitle(L10N.AccountSettings.privacy, for: .normal)
        cguButton.setTitle(L10N.AccountSettings.cgu, for: .normal)
        notificationsLabel.text = L10N.AccountSettings.notifications.uppercased()
        manageNotificationsButton.setTitle(L10N.AccountSettings.manageNotifications, for: .normal)
        logoutButton.setTitle(L10N.AccountSettings.logout, for: .normal)
    }
    
    private func setupStyle() {
        titleLabel.font = Fonts.AccountSettings.title
        legalNoticeLabel.font = Fonts.AccountSettings.sectionTitle
        privacyButton.titleLabel?.font = Fonts.AccountSettings.sectionItem
        cguButton.titleLabel?.font = Fonts.AccountSettings.sectionItem
        manageNotificationsButton.titleLabel?.font = Fonts.AccountSettings.sectionItem
        notificationsLabel.font = Fonts.AccountSettings.sectionTitle
        logoutButton.titleLabel?.font = Fonts.AccountSettings.logout
    }
    
    private func showWebview(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let vc = SFSafariViewController(url: url, configuration: config)
        if #available(iOS 13.0, *) {
            vc.modalPresentationStyle = .automatic
        }
        present(vc, animated: true)
    }
}

// MARK: - IBAction
extension AccountSettingsVC {
    @IBAction func onBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onLogoutTapped(_ sender: Any) {
        ManagerAuth.shared.clear()
        delegate?.didLogout()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPrivacyTapped(_ sender: Any) {
        showWebview(with: Constants.Links.privacy)
    }
    
    @IBAction func onCguTapped(_ sender: Any) {
        showWebview(with: Constants.Links.cgu)
    }
    
    @IBAction func onManageNotificationsTapped(_ sender: Any) {
        guard let url = URL(string:UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
