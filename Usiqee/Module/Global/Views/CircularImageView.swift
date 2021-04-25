//
//  CircularImageView.swift
//  Usiqee
//
//  Created by Amine on 21/04/2021.
//

import UIKit

class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}
