//
//  UITableView+M.swift
//  Usiqee
//
//  Created by Amine on 15/05/2021.
//

import UIKit

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = Fonts.Global.emptyMessage
        messageLabel.sizeToFit()

        backgroundView = messageLabel;
    }

    func restore() {
        backgroundView = nil
    }
}
