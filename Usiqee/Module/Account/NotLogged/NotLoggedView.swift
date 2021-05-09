//
//  NotLoggedView.swift
//  Usiqee
//
//  Created by Amine on 02/05/2021.
//

import UIKit

protocol NotLoggedViewDelegate: class {
    func showPreAuthentication()
}

class NotLoggedView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let identifier = "NotLoggedView"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    @IBOutlet weak private var continueButton: FilledButton!
    
    // MARK: - Properties
    weak var delegate: NotLoggedViewDelegate?
    
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
    
    private func loadView() {
        Bundle.main.loadNibNamed(Constants.identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupView() {
        setupLabels()
        setupContinueButton()
    }
    
    private func setupContinueButton() {
        continueButton.setTitle(L10N.AccountNotLogged.continue, for: .normal)
        continueButton.titleLabel?.font = Fonts.AccountNotLogged.continue
    }
    
    private func setupLabels() {
        titleLabel.font = Fonts.AccountNotLogged.title
        titleLabel.text = L10N.AccountNotLogged.title
        subtitleLabel.font = Fonts.AccountNotLogged.subtitle
        subtitleLabel.text = L10N.AccountNotLogged.subtitle
    }
}

// MARK: - IBActions
extension NotLoggedView {
    @IBAction func onContinueToggle() {
        delegate?.showPreAuthentication()
    }
}
