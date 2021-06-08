//
//  EventsFilterVC.swift
//  Usiqee
//
//  Created by Amine on 27/05/2021.
//

import UIKit

class EventsFilterVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak private var validateButton: FilledButton!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var resetButton: UIButton!
    @IBOutlet weak private var titleLabel: UILabel!
    
    private var tableviewHandler = EventsFilterTableViewHandler()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Privates
    private func setupView() {
        setupTableview()
        setupFonts()
        setupDescriptions()
    }
    
    private func setupFonts() {
        titleLabel.font = Fonts.EventsFilter.title
        resetButton.titleLabel?.font = Fonts.EventsFilter.resetButton
        validateButton.titleLabel?.font = Fonts.EventsFilter.validateButton
    }
    
    private func setupDescriptions() {
        titleLabel.text = L10N.EventsFilter.title
        resetButton.setTitle(L10N.EventsFilter.resetButton, for: .normal)
        validateButton.setTitle(L10N.EventsFilter.validateButton, for: .normal)
    }
    
    private func setupTableview() {
        tableView.register(
            EventsFilterHeaderCell.Constants.nib,
            forHeaderFooterViewReuseIdentifier: EventsFilterHeaderCell.Constants.identifier
        )
        tableView.register(EventsFilterSwitchCell.Constants.nib, forCellReuseIdentifier: EventsFilterSwitchCell.Constants.identifier)
        tableView.register(EventsFilterEventTypeCell.Constants.nib, forCellReuseIdentifier: EventsFilterEventTypeCell.Constants.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - IBActions
extension EventsFilterVC {
    @IBAction func onResetTapped() {
        tableviewHandler.reset()
        tableView.reloadData()
    }
    
    @IBAction func onCancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onValidationTapped() {
        tableviewHandler.validate()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension EventsFilterVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        tableviewHandler.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableviewHandler.sectiontype(at: section) {
        case .followed:
            return 1
        case .event:
            return tableviewHandler.events.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultCell = UITableViewCell()
        
        guard let cellType = tableviewHandler.item(for: indexPath) else {
            return defaultCell
        }
        
        switch cellType {
        case let .followed(isSelected: isSelected):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EventsFilterSwitchCell.Constants.identifier) as? EventsFilterSwitchCell else {
                return defaultCell
            }
            
            cell.configure(title: L10N.EventsFilter.followersFilter, isSelected: isSelected, delegate: self)
            return cell
        case let .event(event):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EventsFilterEventTypeCell.Constants.identifier) as? EventsFilterEventTypeCell else {
                return defaultCell
            }
            
            cell.configure(event: event)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellType = tableviewHandler.item(for: indexPath) else {
            return 0
        }
        
        switch cellType {
        case .followed:
            return EventsFilterSwitchCell.Constants.height
        case .event:
            return EventsFilterEventTypeCell.Constants.height
        }
    }
}

// MARK: - UITableViewDataSource
extension EventsFilterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        EventsFilterHeaderCell.Constants.height
     }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventsFilterHeaderCell.Constants.identifier) as? EventsFilterHeaderCell else { return UITableViewHeaderFooterView() }
        header.set(title: tableviewHandler.headerTitle(for: section))
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellType = tableviewHandler.item(for: indexPath) else {
            return
        }
        
        switch cellType {
        case .event:
            tableviewHandler.didSelectEvent(at: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .fade)
        case .followed:
            break
        }
    }
}

// MARK: - EventsFilterSwitchCellDelegate
extension EventsFilterVC: EventsFilterSwitchCellDelegate {
    func didUpdateStatus() {
        tableviewHandler.showOnlyFollowed.toggle()
    }
}
