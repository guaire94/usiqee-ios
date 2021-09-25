//
//  AccountSettingsVC.swift
//  Usiqee
//
//  Created by Amine on 04/05/2021.
//

import UIKit
import SafariServices
import StoreKit
import MessageUI

protocol AccountSettingsVCDelegate: class {
    func didUpdateInformation()
}

class AccountSettingsVC: UIViewController {
    
    // MARK: - Constants
    enum Constants {
        static let identifier: String = "AccountSettingsVC"
        fileprivate static let placeHolderImage: UIImage = #imageLiteral(resourceName: "userPlaceholder")
        fileprivate static let editProfileButtonCornerRadius: CGFloat = 10
        fileprivate enum Links {
            static let privacy: String = "https://usiqee-44c2e.web.app/privacy-policy.html"
            static let termsAndConditions: String = "https://usiqee-44c2e.web.app/terms-and-conditions.html"
        }
        
        fileprivate enum EmailInformation {
            static let email: String = "usiqee.app@gmail.com"
            static let subject: String = "[USIQEE][FEEDBACK]"
            static let gmailScheme: String = "googlegmail://"
        }
        fileprivate enum SendEmailAlert {
            static let apple: String = "Apple mail"
            static let gmail: String = "Gmail"
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var legalNoticeLabel: UILabel!
    @IBOutlet weak private var privacyButton: UIButton!
    @IBOutlet weak private var termsAndConditionsButton: UIButton!
    @IBOutlet weak private var logoutButton: FilledButton!
    @IBOutlet weak private var notificationsLabel: UILabel!
    @IBOutlet weak private var manageNotificationsButton: UIButton!
    @IBOutlet weak private var profileLabel: UILabel!
    @IBOutlet weak private var userAvatar: CircularImageView!
    @IBOutlet weak private var usernameLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var editProfileButton: FilledButton!
    @IBOutlet weak private var supportLabel: UILabel!
    @IBOutlet weak private var feedbackButton: UIButton!
    @IBOutlet weak private var contactButton: UIButton!
    
    weak var delegate: AccountSettingsVCDelegate?
    
    private var emailBody: String {
        var result: String = "\n\n\n"
        result += "System: \(UIDevice.current.systemVersion)\n"
        result += "Device: \(UIDevice.current.modelName)\n"
        guard let infoDictionary = Bundle.main.infoDictionary,
              let version = infoDictionary["CFBundleShortVersionString"] as? String else {
            return result
        }
        
        result += "Version: \(version)"
        return result
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        HelperTracking.track(item: .settings)
        setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AccountUpdateProfileVC.Constants.identifier {
            guard let vc = segue.destination as? AccountUpdateProfileVC else { return }
            vc.delegate = self
        }
    }
    
    // MARK: - Private
    private func setupView() {
        setupTranslation()
        setupStyle()
        displayUserInformation()
    }
    
    private func displayUserInformation() {
        guard let user = ManagerAuth.shared.user else {
            return
        }
        
        usernameLabel.text = user.username
        emailLabel.text = user.mail
        
        userAvatar.image = Constants.placeHolderImage
        if let url = URL(string: user.avatar) {
            userAvatar.kf.setImage(with: url)
        }
    }
    
    private func setupTranslation() {
        titleLabel.text = L10N.AccountSettings.title
        legalNoticeLabel.text = L10N.AccountSettings.legalNotice.uppercased()
        profileLabel.text = L10N.AccountSettings.profile.uppercased()
        privacyButton.setTitle(L10N.AccountSettings.privacy, for: .normal)
        termsAndConditionsButton.setTitle(L10N.AccountSettings.cgu, for: .normal)
        notificationsLabel.text = L10N.AccountSettings.notifications.uppercased()
        manageNotificationsButton.setTitle(L10N.AccountSettings.manageNotifications, for: .normal)
        logoutButton.setTitle(L10N.AccountSettings.logout, for: .normal)
        editProfileButton.setTitle(L10N.AccountSettings.editProfile, for: .normal)
        supportLabel.text = L10N.AccountSettings.support.uppercased()
        feedbackButton.setTitle(L10N.AccountSettings.feedback, for: .normal)
        contactButton.setTitle(L10N.AccountSettings.contact, for: .normal)
    }
    
    private func setupStyle() {
        titleLabel.font = Fonts.AccountSettings.title
        profileLabel.font = Fonts.AccountSettings.sectionTitle
        emailLabel.font = Fonts.AccountSettings.sectionItem
        usernameLabel.font = Fonts.AccountSettings.sectionItem
        legalNoticeLabel.font = Fonts.AccountSettings.sectionTitle
        privacyButton.titleLabel?.font = Fonts.AccountSettings.sectionItem
        termsAndConditionsButton.titleLabel?.font = Fonts.AccountSettings.sectionItem
        manageNotificationsButton.titleLabel?.font = Fonts.AccountSettings.sectionItem
        notificationsLabel.font = Fonts.AccountSettings.sectionTitle
        logoutButton.titleLabel?.font = Fonts.AccountSettings.logout
        editProfileButton.layer.cornerRadius = Constants.editProfileButtonCornerRadius
        editProfileButton.titleLabel?.font = Fonts.AccountSettings.editProfile
        supportLabel.font = Fonts.AccountSettings.sectionTitle
        feedbackButton.titleLabel?.font = Fonts.AccountSettings.sectionItem
        contactButton.titleLabel?.font = Fonts.AccountSettings.sectionItem
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
    
    private func sendMail() {
        let canSendViaAppleMail = MFMailComposeViewController.canSendMail()
        
        var canSendViaGmail = false
        if let url = URL(string: Constants.EmailInformation.gmailScheme) {
           canSendViaGmail = UIApplication.shared.canOpenURL(url)
        }
        
        switch (canSendViaAppleMail, canSendViaGmail) {
        case (true, true):
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: Constants.SendEmailAlert.apple, style: .default, handler: { (_) in
                self.sendViaAppleMail()
            }))
            
            alert.addAction(UIAlertAction(title: Constants.SendEmailAlert.gmail, style: .default, handler: { (_) in
                self.sendViaGmail()
            }))
            
            alert.addAction(UIAlertAction(title: L10N.global.action.cancel, style: .cancel, handler: nil))
            
            present(alert, animated: true)
        case (true, false):
            sendViaAppleMail()
        case (false, true):
            sendViaGmail()
        default:
            showError(title: L10N.AccountSettings.NoContactEmail.title, message: L10N.AccountSettings.NoContactEmail.message(Constants.EmailInformation.email))
        }
    }
    
    private func sendViaAppleMail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients([Constants.EmailInformation.email])
        composeVC.setSubject(Constants.EmailInformation.subject)
        composeVC.setMessageBody(emailBody, isHTML: false)
        self.present(composeVC, animated: true, completion: nil)
    }
    
    private func sendViaGmail() {
        let to = Constants.EmailInformation.email
        guard let subject = Constants.EmailInformation.subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let emailBody = emailBody.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "\(Constants.EmailInformation.gmailScheme)co?to=\(to)&subject=\(subject)&body=\(emailBody)") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - IBAction
extension AccountSettingsVC {
    @IBAction func onBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onLogoutTapped(_ sender: Any) {
        HelperTracking.track(item: .settingsLogout)
        ManagerAuth.shared.clear()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPrivacyTapped(_ sender: Any) {
        HelperTracking.track(item: .settingsPolicy)
        showWebview(with: Constants.Links.privacy)
    }
    
    @IBAction func onTermsAndConditionsTapped(_ sender: Any) {
        HelperTracking.track(item: .settingsTermsAndConditions)
        showWebview(with: Constants.Links.termsAndConditions)
    }
    
    @IBAction func onManageNotificationsTapped(_ sender: Any) {
        guard let url = URL(string:UIApplication.openSettingsURLString) else { return }
        HelperTracking.track(item: .settingsNotifications)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func onFeedbackTapped(_ sender: Any) {
        if #available(iOS 14.0, *),
           let currentScene = UIApplication.shared.currentScene {
            SKStoreReviewController.requestReview(in: currentScene)
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
    @IBAction func onContactTapped(_ sender: Any) {
        sendMail()
    }
}

// MARK: - AccountUpdateProfileVCDelegate
extension AccountSettingsVC: AccountUpdateProfileVCDelegate {
    func didUpdateProfile() {
        displayUserInformation()
        delegate?.didUpdateInformation()
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension AccountSettingsVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
