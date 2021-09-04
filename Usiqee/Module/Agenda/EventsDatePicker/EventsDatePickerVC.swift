//
//  EventsDatePickerVC.swift
//  Usiqee
//
//  Created by Amine on 02/06/2021.
//

import UIKit

protocol EventsDatePickerVCDelegate: AnyObject {
    func didUpdateDate()
}

class EventsDatePickerVC: UIViewController {

    // MARK: - Constants
    enum Constants {
        static let identifier: String = "EventsDatePickerVC"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var datePicker: MonthYearDatePickerView!
    @IBOutlet weak private var validateButton: UIButton!
    @IBOutlet weak private var titleLabel: UILabel!
    
    // MARK: - Properties
    private var selectedDate: Date?
    weak var delegate: EventsDatePickerVCDelegate?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        HelperTracking.track(item: .agendaDatePicker)
        setupView()
    }
    
    // MARK: - Private
    private func setupView() {
        setupFonts()
        setupDescriptions()
        setupDatePicker()
    }
    
    private func setupDatePicker() {
        datePicker.pickerDelegate = self
        datePicker.set(date: ManagerEvents.shared.selectedDate)
    }
    
    private func setupFonts() {
        titleLabel.font = Fonts.EventsDateFilter.title
        validateButton.titleLabel?.font = Fonts.EventsDateFilter.validateButton
    }
    
    private func setupDescriptions() {
        titleLabel.text = L10N.EventsDateFilter.title
        validateButton.setTitle(L10N.EventsDateFilter.validateButton, for: .normal)
    }
}

// MARK : - MonthYearDatePickerViewDelegate
extension EventsDatePickerVC: MonthYearDatePickerViewDelegate {
    func didUpdateValue() {
        selectedDate = datePicker.date
    }
}

// MARK: - IBActions
extension EventsDatePickerVC {
    
    @IBAction func onCancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onValidationTapped() {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        guard let date = selectedDate else {
            return
        }
        
        ManagerEvents.shared.selectedDate = date
        delegate?.didUpdateDate()
    }
}
