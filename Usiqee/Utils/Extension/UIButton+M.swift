//
//  UIButton+M.swift
//  Usiqee
//
//  Created by Quentin Gallois on 28/10/2020.
//

import UIKit

extension UIButton {
    
    func loadingIndicator(show: Bool,
                          color: UIColor = UIColor.white,
                          backgroundColor: UIColor? = nil) {
        let tag = 1000
        if show {
            isEnabled = false
            let indicator = UIActivityIndicatorView()
            let buttonHeight = bounds.size.height
            let buttonWidth = bounds.size.width
            let view = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
            view.backgroundColor = backgroundColor ?? self.backgroundColor
            view.tag = tag
            indicator.center = CGPoint(x:buttonWidth/2, y:buttonHeight/2)
            indicator.color = color
            view.addSubview(indicator)
            indicator.startAnimating()
            addSubview(view)
        } else {
            DispatchQueue.main.async {
                if let indicatorView = self.viewWithTag(tag) {
                    self.isEnabled = true
                    indicatorView.removeFromSuperview()
                }
            }
        }
    }
    
    func setBackgroundColor(_ color: UIColor) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let currentGraphicsContext = UIGraphicsGetCurrentContext() {
            currentGraphicsContext.setFillColor(color.cgColor)
            currentGraphicsContext.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: .normal)
    }
}
