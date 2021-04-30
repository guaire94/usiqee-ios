//
//  UITextField+M.swift
//  Usiqee
//
//  Created by Amine on 28/04/2021.
//

import UIKit

extension UITextField {
    func setClearButton(tintColor: UIColor) {
        guard let clearButton = value(forKey: "_clearButton") as? UIButton else {
            return
        }

        let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        clearButton.setImage(templateImage, for: .normal)
        clearButton.tintColor = tintColor
    }
}
