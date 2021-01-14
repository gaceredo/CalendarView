//
//  DateModel.swift
//  CalendarView
//
//  Created by Luis Aceredo on 14/01/21.
//

import Foundation

public struct DateModel: Hashable {
    var day: Int
    var nameDay: String
    var monthAsString: String
    var monthAsInt: Int
    var year: String
    var isSelected: Bool
    
    public init(day: Int = 0,
                nameDay: String = "",
                monthAsString: String = "",
                monthAsInt: Int = 0,
                year: String = "",
                isSelected: Bool = false) {
        self.day = day
        self.nameDay = nameDay
        self.monthAsString = monthAsString
        self.monthAsInt = monthAsInt
        self.year = year
        self.isSelected = isSelected
    }
    
    public func date() -> Date? {
        let dateFormat = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.date(from: "\(year)-\(monthAsInt)-\(day)")
    }
}
