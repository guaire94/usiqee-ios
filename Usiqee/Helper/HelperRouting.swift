//
//  HelperRouting.swift
//  Usiqee
//
//  Created by Amine on 09/06/2021.
//

import UIKit
import StoreKit

class HelperRouting {
    
    static let shared = HelperRouting()

    // MARK: - Properties
    private var isReadyToRedirect: Bool = false
    
    // MARK: - Public
    func routeToHome() {
        isReadyToRedirect = true
        UIViewController.displayHome()
        handleRedirect()
    }
    
    func redirect() {
        guard isReadyToRedirect else { return }
        handleRedirect()
    }
    
    // MARK: - Private
    private func handleRedirect() {
        guard let currentDeepLink = ManagerDeepLink.shared.currentDeepLink,
              let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
        
        switch currentDeepLink {
        case let .eventDetails(eventId: eventId):
            guard let eventDetailsVC = UIViewController.eventDetailsVC else { return }
            
            rootViewController.presentedViewController?.dismiss(animated: false, completion: nil)
            
            eventDetailsVC.eventId = eventId
            let navigationController = UINavigationController(rootViewController: eventDetailsVC)
            navigationController.navigationBar.isHidden = true
            
            rootViewController.present(navigationController, animated: true, completion: nil)
            break
        case let .newsDetails(newsId: newsId):
            guard let newsDetailsVC = UIViewController.newsDetailsVC,
                  let tabVC = rootViewController as? TabsVC else { return }
            
            rootViewController.presentedViewController?.dismiss(animated: false, completion: nil)
            if tabVC.selectedIndex != 0 {
                tabVC.selectedIndex = 0
            }
            
            newsDetailsVC.newsId = newsId
            tabVC.allVC.first?.navigationController?.pushViewController(newsDetailsVC, animated: true)
            break
        case .storeFeedback:
            if #available(iOS 14.0, *),
               let currentScene = UIApplication.shared.currentScene {
                SKStoreReviewController.requestReview(in: currentScene)
            } else {
                SKStoreReviewController.requestReview()
            }
        }
    }
}
