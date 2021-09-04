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
        HelperTracking.track(item: .alertError(title: title, message: message))
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: L10N.global.action.ok, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    static func displayHome() {
        guard let homeNavigationController = MStoryboard.Home.storyboard.instantiateInitialViewController() else {
            fatalError("Load initial view controller from '\(MStoryboard.Home.rawValue)' Storyboard have failed")
        }
        UIApplication.shared.keyWindow?.rootViewController = homeNavigationController
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
    
    static var eventDetailsVC: EventDetailsVC? {
        guard let eventDetails = MStoryboard.Agenda.storyboard.instantiateViewController(withIdentifier: EventDetailsVC.Constants.identifer) as? EventDetailsVC else {
            fatalError("Load initial view controller from '\(MStoryboard.Agenda.rawValue)' Storyboard have failed")
        }
        
        return eventDetails
    }
    
    static var bandDetailsVC: BandDetailsVC? {
        guard let bandDetails = MStoryboard.Artist.storyboard.instantiateViewController(withIdentifier: BandDetailsVC.Constants.identifer) as? BandDetailsVC else {
            fatalError("Load initial view controller from '\(MStoryboard.Artist.rawValue)' Storyboard have failed")
        }
        
        return bandDetails
    }
    
    static var artistDetailsVC: ArtistDetailsVC? {
        guard let artistDetails = MStoryboard.Artist.storyboard.instantiateViewController(withIdentifier: ArtistDetailsVC.Constants.identifer) as? ArtistDetailsVC else {
            fatalError("Load initial view controller from '\(MStoryboard.Artist.rawValue)' Storyboard have failed")
        }
        
        return artistDetails
    }
    
    static var newsDetailsVC: NewsDetailsVC? {
        guard let newsDetails = MStoryboard.News.storyboard.instantiateViewController(withIdentifier: NewsDetailsVC.Constants.identifier) as? NewsDetailsVC else {
            fatalError("Load initial view controller from '\(MStoryboard.News.rawValue)' Storyboard have failed")
        }
        
        return newsDetails
    }
}
