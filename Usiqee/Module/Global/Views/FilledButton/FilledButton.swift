//
//  FilledButton.swift
//  Usiqee
//
//  Created by Amine on 08/05/2021.
//

import UIKit

class FilledButton: UIButton {
    
    // MARK: - Properties
    var isFilled: Bool = true {
        didSet {
            updateBackgroundColor()
        }
    }
    
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
        layer.borderWidth = 2
        layer.borderColor = Colors.purple.cgColor
        clipsToBounds = true
        tintColor = .white
        updateBackgroundColor()
    }
    
    private func updateBackgroundColor() {
        backgroundColor = isFilled ? Colors.purple : .clear
    }
}
