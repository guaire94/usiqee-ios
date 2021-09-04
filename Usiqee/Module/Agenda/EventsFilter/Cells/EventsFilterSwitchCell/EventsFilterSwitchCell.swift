//
//  EventsFilterSwitchCell.swift
//  Usiqee
//
//  Created by Amine on 28/05/2021.
//

import UIKit

protocol EventsFilterSwitchCellDelegate: AnyObject {
    func didUpdateStatus()
}

class EventsFilterSwitchCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let identifier = "EventsFilterSwitchCell"
        static let nib = UINib(nibName: identifier, bundle: nil)
        static let height: CGFloat = 50
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var activationSwitch: UISwitch!
    
    // MARK: - Properties
    private weak var delegate: EventsFilterSwitchCellDelegate?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = Fonts.EventsFilter.Cell.title
    }

    func configure(title: String, isSelected: Bool, delegate: EventsFilterSwitchCellDelegate?) {
        titleLabel.text = title
        activationSwitch.isOn = isSelected
        self.delegate = delegate
    }
}

// MARK: - EventsFilterSwitchCell
extension EventsFilterSwitchCell {
    @IBAction func onActivationValueChanged(_ sender: Any) {
        delegate?.didUpdateStatus()
    }
}
