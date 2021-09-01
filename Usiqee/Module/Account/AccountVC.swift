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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == NewsDetailsVC.Constants.identifier {
            guard let vc = segue.destination as? NewsDetailsVC,
                  let news = sender as? NewsItem else {
                return
            }
            
            vc.news = news
        } else if segue.identifier == AccountSettingsVC.Constants.identifier {
            guard let vc = segue.destination as? AccountSettingsVC else { return }
            
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
        displayAuthentication()
    }
}

// MARK: - AccountDetailsViewDelegate
extension AccountVC: AccountDetailsViewDelegate {
    func didTapSettings() {
        performSegue(withIdentifier: AccountSettingsVC.Constants.identifier, sender: nil)
    }
    
    func didTapLikedNews(likedNews: RelatedNews) {
        ServiceNews.syncLikedNews(likedNews: likedNews) { (newsItem) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: NewsDetailsVC.Constants.identifier, sender: newsItem)
            }
        }
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
    
    func didUpdateLikedNews() {
        accountDetailsView.refresh()
    }
}

// MARK: - AccountSettingsVCDelegate
extension AccountVC: AccountSettingsVCDelegate {
    func didUpdateInformation() {
        accountDetailsView.reload()
    }
}
