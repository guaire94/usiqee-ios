//
//  AgendaVC.swift
//  Usiqee
//
//  Created by Quentin Gallois on 10/11/2020.
//

import UIKit
import Firebase

class AgendaVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "AgendaVC"
        fileprivate static let dateFormat: String = "MMMM yyyy"
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var datePickerButton: UIButton!
    @IBOutlet weak private var filterButtonBadge: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var loaderView: UIView!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        HelperTracking.track(item: .agenda)
        if !HelperOnBoarding.shared.haveSeenAgendaOnBoarding {
            displayOnBoarding(item: .agenda)
        }
        setUpView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EventsDatePickerVC.Constants.identifier {
            guard let vc = segue.destination as? EventsDatePickerVC else {
                return
            }
            
            vc.delegate = self
        } else if segue.identifier == EventDetailsVC.Constants.identifer {
            guard let nv = segue.destination as? UINavigationController,
                  let vc = nv.viewControllers.first as? EventDetailsVC,
                  let event = sender as? EventItem else {
                return
            }
            
            vc.event = event
        }
    }

    // MARK: - Privates
    private func setUpView() {
        setupTableView()
        setupDataPickerButton()
        setupListener()
        setupFilterBadge()
        loaderView.isHidden = false
    }
    
    private func setupFilterBadge() {
        filterButtonBadge.isHidden = true
        filterButtonBadge.font = Fonts.Events.filterBadge
    }
    
    private func setupListener() {
        ManagerEvents.shared.setupListener()
        ManagerEvents.shared.delegate = self
    }
    
    private func setupDataPickerButton() {
        displaySelectedDate()
        datePickerButton.titleLabel?.font = Fonts.Events.title
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: EventCell.Constants.identifier, bundle: nil),
                           forCellReuseIdentifier: EventCell.Constants.identifier)
        tableView.register(UINib(nibName: DateSectionCell.Constants.identifier, bundle: nil),
                           forHeaderFooterViewReuseIdentifier: DateSectionCell.Constants.identifier)
    }
    
    private func displaySelectedDate() {
        let date = ManagerEvents.shared.selectedDate.stringWith(format: Constants.dateFormat).uppercaseFirstLetter
        datePickerButton.setTitle(date, for: .normal)
    }
    
    private func setupFooter() {
        let height: CGFloat
        let message: String?
        if ManagerEvents.shared.eventsByDate.isEmpty {
            height = EventFooterView.Constants.Heights.withMessage
            message = L10N.Events.emptyListMessage
        } else {
            height = EventFooterView.Constants.Heights.withoutMessage
            message = nil
        }
        let footer = EventFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: height))
        footer.configure(message: message, delegate: self)
        tableView.tableFooterView = footer
    }
    
    private func setupHeader() {
        let height = EventHeaderView.Constants.height
        let header = EventHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: height))
        header.configure(delegate: self)
        tableView.tableHeaderView = header
    }
    
    private func displayFiltersCountIfNeeded() {
        let filtersCount = ManagerEvents.shared.numberOfActiveFilters
        filterButtonBadge.text = "\(filtersCount)"
        filterButtonBadge.isHidden = filtersCount == .zero
    }
}

// MARK: - UITableViewDataSource
extension AgendaVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        setupFooter()
        setupHeader()
        return ManagerEvents.shared.eventsByDate.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        DateSectionCell.Constants.height
     }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DateSectionCell.Constants.identifier) as? DateSectionCell else { return UITableViewHeaderFooterView() }
        header.setup(date: ManagerEvents.shared.eventsByDate[section].date)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ManagerEvents.shared.eventsByDate[section].events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        EventCell.Constants.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: EventCell.Constants.identifier)
        guard let cell = reusableCell as? EventCell else {
            return UITableViewCell()
        }
        let event = ManagerEvents.shared
            .eventsByDate[indexPath.section]
            .events[indexPath.row]
        cell.configure(item: event)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AgendaVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = ManagerEvents.shared
            .eventsByDate[indexPath.section]
            .events[indexPath.row]
        performSegue(withIdentifier: EventDetailsVC.Constants.identifer, sender: event)
    }
}

// MARK: - EventsDatePickerVCDelegate
extension AgendaVC: EventsDatePickerVCDelegate {
    func didUpdateDate() {
        displaySelectedDate()
        ManagerEvents.shared.setupListener()
    }
}

// MARK: - ManagerEventDelegate
extension AgendaVC: ManagerEventDelegate {
    func didUpdateEvents() {
        tableView.reloadData()
        displayFiltersCountIfNeeded()
    }
    
    func didStartLoading() {
        loaderView.isHidden = false
    }
    
    func didFinishLoading() {
        loaderView.isHidden = true
    }
    
    func scroll(to section: Int) {
        tableView.scrollToRow(at: IndexPath(row: .zero, section: section), at: .top, animated: true)
    }
}

// MARK: - EventFooterViewDelegate
extension AgendaVC: EventFooterViewDelegate {
    func didTapNextMonth() {
        HelperTracking.track(item: .agendaNextMonth)
        ManagerEvents.shared.didSelectNextMonth()
        displaySelectedDate()
    }
}

// MARK: - EventHeaderViewDelegate
extension AgendaVC: EventHeaderViewDelegate {
    func didTapPreviousMonth() {
        HelperTracking.track(item: .agendaPreviousMonth)
        ManagerEvents.shared.didSelectPreviousMonth()
        displaySelectedDate()
    }
}
