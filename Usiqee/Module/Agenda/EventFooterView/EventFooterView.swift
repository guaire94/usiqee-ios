//
//  EventFooterView.swift
//  Usiqee
//
//  Created by Amine on 07/06/2021.
//

import UIKit

protocol EventFooterViewDelegate: AnyObject {
    func didTapNextMonth()
}

class EventFooterView: UIView {
    
    // MARK: - Constants
    enum Constants {
        fileprivate static let identifier = "EventFooterView"
        enum Heights {
            static let withMessage: CGFloat = 150
            static let withoutMessage: CGFloat = 80
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var nextMonthButton: UIButton!
    @IBOutlet weak private var messageLabel: UILabel!
    
    // MARK: - Properties
    weak var delegate: EventFooterViewDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func configure(message: String?, delegate: EventFooterViewDelegate?) {
        messageLabel.text = message
        self.delegate = delegate
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
        nextMonthButton?.titleLabel?.font = Fonts.Events.Cell.nextMonthButton
        nextMonthButton.setTitle(L10N.Events.nextMonth, for: .normal)
    }
}

// MARK: - IBOutlet
extension EventFooterView {
    @IBAction func onNextTapped() {
        delegate?.didTapNextMonth()
    }
}
