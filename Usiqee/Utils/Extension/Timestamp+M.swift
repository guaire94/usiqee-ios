//
//  Timestamp+M.swift
//  Usiqee
//
//  Created by Quentin Gallois on 01/11/2020.
//

import Firebase

extension Timestamp {
    
    var long: String {
        dateValue().long
    }
    
    var short: String {
        dateValue().short
    }

    var hour: String {
        dateValue().hour
    }
    
    var year: String {
        dateValue().year
    }
    
    var withoutTime: Date {
        dateValue().withoutTime ?? dateValue()
    }
}

extension Date {
    
    var timestamp: Timestamp {
        Timestamp(date: self)
    }

    var long: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    var full: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    var time: String {
        stringWith(format: "hh:mm a")
    }
    
    var short: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

    var hour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    var timeAgo: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }

    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    func stringWith(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    var firstMonthDay: Date? {
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: self)
        guard let year = dateComponents.year,
              let month = dateComponents.month else {
            return nil
        }
        
        return Date(month: month, year: year)
    }
    
    var withoutTime: Date? {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        guard let year = dateComponents.year,
              let month = dateComponents.month,
              let day = dateComponents.day else {
            return nil
        }
        
        return Date(day: day, month: month, year: year)
    }
    
    var lastMonthDay: Date? {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self)
    }
    
    var nextMonth: Date? {
        Calendar.current.date(byAdding: DateComponents(month: 1), to: self)
    }
    
    init?(month: Int, year: Int) {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier:"GMT")
        formatter.dateFormat = "yyyy/MM"
        guard let d = formatter.date(from: "\(year)/\(month)") else {
            return nil
        }
        self.init(timeInterval: 0, since: d)
    }
    
    init?(day: Int, month: Int, year: Int) {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier:"GMT")
        formatter.dateFormat = "yyyy/MM/d"
        guard let d = formatter.date(from: "\(year)/\(month)/\(day)") else {
            return nil
        }
        self.init(timeInterval: 0, since: d)
    }
}

