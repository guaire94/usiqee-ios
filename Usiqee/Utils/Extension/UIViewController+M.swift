//
//  UIViewController+M.swift
//  Usiqee
//
//  Created by Quentin Gallois on 20/10/2020.
//

import UIKit
import FirebaseAnalytics

// MARK: - Show alert
extension UIViewController {
    
    func showError(title: String, message: String) {
        Analytics.logEvent(MEvent.AlertError.rawValue, parameters: ["title": title, "message": message])
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: L10N.global.action.ok, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func displayHome() {
        guard let homeNavigationController = MStoryboard.Home.storyboard.instantiateInitialViewController() else {
            fatalError("Load initial view controller from '\(MStoryboard.Home.rawValue)' Storyboard have failed")
        }
        UIApplication.shared.keyWindow?.rootViewController = homeNavigationController
        navigationController?.popToRootViewController(animated: false)
    }
    
    func displayAuthentication(with delegate: PreAuthVCDelegate? = nil) {
        guard let authenticationNavigationController = MStoryboard.Auth.storyboard.instantiateInitialViewController() as? PreAuthVC else {
            fatalError("Load initial view controller from '\(MStoryboard.Home.rawValue)' Storyboard have failed")
        }
        authenticationNavigationController.delegate = delegate
        let navigationController = UINavigationController(rootViewController: authenticationNavigationController)
        navigationController.isNavigationBarHidden = true
        present(navigationController, animated: true, completion: nil)
    }
}
