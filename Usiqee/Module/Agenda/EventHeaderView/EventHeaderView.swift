//
//  EventHeaderView.swift
//  Usiqee
//
//  Created by Amine on 22/06/2021.
//

import UIKit

protocol EventHeaderViewDelegate: AnyObject {
    func didTapPreviousMonth()
}

class EventHeaderView: UIView {
    
    // MARK: - Constants
    enum Constants {
        fileprivate static let identifier = "EventHeaderView"
        fileprivate static let dateFormat: String = "MMMM yyyy"
        static let height: CGFloat = 50
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var previousMonthLabel: UILabel!
    
    // MARK: - Properties
    weak var delegate: EventHeaderViewDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func configure(delegate: EventHeaderViewDelegate?) {
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
        previousMonthLabel.font = Fonts.Events.Cell.previousMonthButton
        guard let date = ManagerEvents.shared.selectedDate.previousMonth else {
            return
        }
        previousMonthLabel.text = date.stringWith(format: Constants.dateFormat)
    }
}

// MARK: - IBOutlet
extension EventHeaderView {
    @IBAction func onPreviousTapped() {
        delegate?.didTapPreviousMonth()
    }
}
