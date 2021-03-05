//
//  UIButton+M.swift
//  Usiqee
//
//  Created by Quentin Gallois on 28/10/2020.
//

import UIKit

var BUTTON_TITLE: String? = ""
var BUTTON_IMAGE: UIImage? = nil

extension UIButton {
    
    func loadingIndicator(show: Bool, color: UIColor = UIColor.white) {
        let tag = 1000
        if show {
            isEnabled = false
            
            BUTTON_TITLE = title(for: .normal)
            setTitle("", for: .normal)
            
            BUTTON_IMAGE = image(for: .normal)
            setImage(nil, for: .normal)
            
            let indicator = UIActivityIndicatorView()
            indicator.center = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
            indicator.tag = tag
            indicator.color = color
            
            addSubview(indicator)
            indicator.startAnimating()
        } else {
            DispatchQueue.main.async {
                if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                    self.isEnabled = true
                    self.setTitle(BUTTON_TITLE, for: .normal)
                    self.setImage(BUTTON_IMAGE, for: .normal)
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                }
            }
        }
    }
}
