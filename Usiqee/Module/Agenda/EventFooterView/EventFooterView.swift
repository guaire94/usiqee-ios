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
        fileprivate static let dateFormat: String = "MMMM yyyy"
        enum Heights {
            static let withMessage: CGFloat = 170
            static let withoutMessage: CGFloat = 100
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var nextMonthLabel: UILabel!
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
        nextMonthLabel.font = Fonts.Events.Cell.nextMonthButton
        guard let date = ManagerEvents.shared.selectedDate.nextMonth else {
            return
        }
        nextMonthLabel.text = date.stringWith(format: Constants.dateFormat)
    }
}

// MARK: - IBOutlet
extension EventFooterView {
    @IBAction func onNextTapped() {
        delegate?.didTapNextMonth()
    }
}
