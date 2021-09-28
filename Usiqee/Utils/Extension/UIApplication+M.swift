//
//  UIApplication+M.swift
//  Usiqee
//
//  Created by Amine on 16/09/2021.
//

import UIKit

@available(iOS 13.0, *)
extension UIApplication {
    var currentScene: UIWindowScene? {
        connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}
