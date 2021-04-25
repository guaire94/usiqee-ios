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
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties
    var eventsByDate: [(date: Date, events: [Event])] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        syncEvents()
    }
    
    func syncEvents() {
        
    }

    // MARK: - Privates
    private func setUpView() {
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.register(UINib(nibName: EventCell.Constants.identifier, bundle: nil),
                           forCellReuseIdentifier: EventCell.Constants.identifier)
        tableView.register(UINib(nibName: DateSectionCell.Constants.identifier, bundle: nil),
                           forHeaderFooterViewReuseIdentifier: DateSectionCell.Constants.identifier)
    }
}

// MARK: - UITableViewDataSource
extension AgendaVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        eventsByDate.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        DateSectionCell.Constants.height
     }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DateSectionCell.Constants.identifier) as? DateSectionCell else { return UITableViewHeaderFooterView() }
        header.setUp(date: eventsByDate[section].date.long)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventsByDate[section].events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        EventCell.Constants.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: EventCell.Constants.identifier, for: indexPath)
        guard let cell = reusableCell as? EventCell else {
            return UITableViewCell()
        }
        let event = eventsByDate[indexPath.section].events[indexPath.row]
        cell.setUp(event: event)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AgendaVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
