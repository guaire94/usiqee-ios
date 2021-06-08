//
//  MonthYearDatePickerView.swift
//  Usiqee
//
//  Created by Amine on 01/06/2021.
//

import UIKit

protocol MonthYearDatePickerViewDelegate: AnyObject {
    func didUpdateValue()
}

class MonthYearDatePickerView: UIPickerView {
    
    // MARK: - Enums
    private enum DatePickerComponent : Int {
        case month, year
    }
    
    private enum Constants {
        fileprivate static let months = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre","Octobre", "Novembre", "Décembre"]
        fileprivate static let componentsCount = 2
        fileprivate static let textColor = UIColor.white
        fileprivate static let textFont = Fonts.MonthYearDatePicker.text
        fileprivate static let rowHeight : CGFloat = 44
        fileprivate static let numberOfYears: Int = 5
    }
    
    //MARK: - Properties
    private var minYear = 2021
    private var maxYear = 2026
    private var currentMonth: Int = 0
    private var currentYear: Int = 0
    private var currentMonthIndex: Int = 0
    private var currentYearIndex: Int = 0
        
    private var rowLabel : UILabel {
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: componentWidth, height: Constants.rowHeight))
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }
    
    private var months: [String] {
        guard currentYearIndex == 0 else {
            return Constants.months
        }
        return Array(Constants.months[currentMonth..<12])
    }
    
    private var years : [Int] {
        [Int](minYear...maxYear)
    }
    
    private var componentWidth: CGFloat {
        bounds.size.width / CGFloat(Constants.componentsCount)
    }
    
    // MARK: - Public
    weak var pickerDelegate: MonthYearDatePickerViewDelegate?
    
    var date: Date? {
        let monthIndex = selectedRow(inComponent: DatePickerComponent.month.rawValue)
        let yearIndex = selectedRow(inComponent: DatePickerComponent.year.rawValue)
        
        let month: Int
        if yearIndex == 0 {
            month = monthIndex + currentMonth + 1
        } else {
            month = monthIndex + 1
        }
        let year = years[yearIndex]
        return Date(month: month, year: year)
    }
    
    func set(date: Date) {
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        if let year = dateComponents.year {
            currentYearIndex = max(year-minYear, 0)
            currentYear = year
            selectRow(currentYearIndex, inComponent: 1, animated: true)
        }
        
        if let month = dateComponents.month {
            let monthIndex: Int
            if currentYear == minYear {
                monthIndex = month-currentMonth-1
            } else {
                monthIndex = month-1
            }
            
            currentMonthIndex = max(monthIndex, 0)
            selectRow(currentMonthIndex, inComponent: 0, animated: true)
        }
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadDefaultsParameters()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadDefaultsParameters()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadDefaultsParameters()
    }
    
    //MARK: - Private
    private func isSelectedRow(_ row : Int, component : Int) -> Bool {
        
        if component == DatePickerComponent.month.rawValue {
            return row == currentMonthIndex
        } else if component == DatePickerComponent.year.rawValue {
            return row == currentYearIndex
        }
        return false
    }
    
    private func loadDefaultsParameters() {
        
        let dateComponents = Calendar.current.dateComponents([.month, .year], from: Date())
        if let month = dateComponents.month {
            currentMonth = month-1
        }
        if let year = dateComponents.year {
            currentYear = year
            minYear = year
            maxYear = year + Constants.numberOfYears
        }
        
        delegate = self
        dataSource = self
    }
        
    private func titleForRow(_ row : Int, component : Int) -> String {
        if component == DatePickerComponent.month.rawValue {
            return months[row]
        }
        
        return "\(years[row])"
    }
}

// MARK: - UIPickerViewDelegate
extension MonthYearDatePickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        componentWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label : UILabel
        if view is UILabel {
            label = view as! UILabel
        } else {
            label = rowLabel
        }
        
        label.font = Constants.textFont
        label.textColor = Constants.textColor
        label.text = titleForRow(row, component: component)
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        Constants.rowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == DatePickerComponent.year.rawValue {
            let wasCurrentYear = currentYearIndex == 0
            let currentMonth = selectedRow(inComponent: DatePickerComponent.month.rawValue)
            
            currentYearIndex = row
            reloadAllComponents()
            
            if row == 0 {
                selectRow(0, inComponent: DatePickerComponent.month.rawValue, animated: true)
            } else if wasCurrentYear {
                selectRow(currentMonth+self.currentMonth, inComponent: DatePickerComponent.month.rawValue, animated: true)
            }
            pickerDelegate?.didUpdateValue()
            return
        }
        
        currentMonthIndex = row
        pickerDelegate?.didUpdateValue()
    }
}

// MARK: - UIPickerViewDataSource
extension MonthYearDatePickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        Constants.componentsCount
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == DatePickerComponent.month.rawValue {
            return months.count
        }
        
        return years.count
    }
}
