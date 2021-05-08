//
//  FilledButton.swift
//  Usiqee
//
//  Created by Amine on 08/05/2021.
//

import UIKit

class FilledButton: UIButton {
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Private
    private func commonInit() {
        layer.cornerRadius = 20
        clipsToBounds = true
        setBackgroundColor(Colors.purple)
    }
}
