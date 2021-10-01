//
//  MiniPlayer.swift
//  Mooddy
//
//  Created by Quentin Gallois on 25/08/2019.
//  Copyright © 2019 Quentin Gallois. All rights reserved.
//

import UIKit

class OnBoardingView: UIView {
    
    // MARK: - Constants
    enum Constants {
        static let identifier = "OnBoardingView"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var titlelabel: UILabel!
    @IBOutlet weak private var descriptionlabel: UILabel!

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    convenience init(title: String, description: String) {
        self.init()
        titlelabel.text = title
        descriptionlabel.text = description
    }
        
    // MARK: - Private
    private func commonInit() {
        setUpView()
    }

    private func setUpView() {
        Bundle.main.loadNibNamed(Constants.identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setUpFont()
    }
    
    private func setUpFont() {
        titlelabel.font = Fonts.OnBoarding.title
        descriptionlabel.font = Fonts.OnBoarding.description
    }
}
