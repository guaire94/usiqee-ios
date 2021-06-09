//
//  HelperRouting.swift
//  Usiqee
//
//  Created by Amine on 09/06/2021.
//

import UIKit

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
            guard let eventDetailsVC = UIViewController.eventDetailsVC else {
                return
            }
            
            rootViewController.presentedViewController?.dismiss(animated: false, completion: nil)
            
            eventDetailsVC.eventId = eventId
            rootViewController.present(eventDetailsVC, animated: true, completion: nil)
            break
        }
    }
}
