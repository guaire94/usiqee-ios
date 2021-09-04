//
//  ArtistDiscographyDetailsView.swift
//  Usiqee
//
//  Created by Amine on 28/04/2021.
//

import UIKit

class ArtistDiscographyDetailsView: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Private
    private func commonInit() {
        loadView()
        setupView()
    }

    private func setupView() {
        titleLabel.text = L10N.ArtistDetails.Discography.title
        titleLabel.font = Fonts.ArtistDetails.Discography.title
        subtitleLabel.text = L10N.ArtistDetails.Discography.subtitle
        subtitleLabel.font = Fonts.ArtistDetails.Discography.subtitle
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed("ArtistDiscographyDetailsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
