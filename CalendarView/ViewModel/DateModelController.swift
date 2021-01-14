//
//  DateModelController.swift
//  CalendarView
//
//  Created by Luis Aceredo on 14/01/21.
//

import Foundation

class DateModelController: ObservableObject {
    @Published private(set) var listOfDates: [DateModel] = []
    @Published private(set) var selectedDate = ""
    
    init() {
        getDates()
    }
    
    func toggleIsSelected(date: DateModel) {
        guard let oldIndex = self.listOfDates.firstIndex(where: {$0.isSelected}),
              let index = self.listOfDates.firstIndex(of: date)  else {
            return
        }
        
        listOfDates[oldIndex].isSelected = false
        listOfDates[index].isSelected.toggle()
        selectedDate = listOfDates[index].monthAsString + " " + "\(listOfDates[index].day)"
    }
    
    func nextWeek() {
        let dateFormat = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        guard let month = listOfDates.last?.monthAsInt,
              let day = listOfDates.last?.day,
              let year = listOfDates.last?.year,
              let date = dateFormatter.date(from: "\(year)-\(month)-\(day)") else {
            return
        }
        
        getDates(date: date)
        guard !listOfDates.isEmpty else { return }
        listOfDates[0].isSelected.toggle()
        toggleIsSelected(date: listOfDates[0])
    }
    
    func lastWeek(completed: () -> ()) {
        let dateFormat = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        guard let month = listOfDates.first?.monthAsInt,
              let day = listOfDates.first?.day,
              let year = listOfDates.first?.year,
              let date = dateFormatter.date(from: "\(year)-\(month)-\(day)")
        else {
            return
        }
        if !date.isToday() {
            getDates(date: date, isNextWeek: false)
        } else {
            completed()
        }
        guard !listOfDates.isEmpty else { return }
        listOfDates[0].isSelected = true
        toggleIsSelected(date: listOfDates[0])
    }
    
    private func getDates(date: Date = Date(), isNextWeek: Bool = true) {
        self.listOfDates.removeAll()
        guard let maxDate = Calendar.current.date(byAdding: .day, value: isNextWeek ? 6 : 0, to: date) else { return }
        let delta = Calendar.current.dateComponents([.day], from: date, to: maxDate).day!
        
        var counter = isNextWeek ? 0 : -6
        
        while counter <= delta {
            guard let newDate = Calendar.current.date(byAdding: .day, value: counter, to: date) else { return }
            var model = DateModel()
            let day = Calendar.current.component(.day, from: newDate)
            
            model.day = day
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.locale = Locale(identifier: "es")
            model.nameDay = String(dateFormatter.string(from: newDate).prefix(3)).capitalizingFirstLetter()
            dateFormatter.dateFormat = "LLL"
            
            let month = dateFormatter.string(from: newDate)
            model.monthAsInt = Calendar.current.component(.month, from: newDate)
            model.monthAsString = month
            model.year = Calendar.current.component(.year, from: newDate).description
            
            counter = counter + 1
            
            if (day == Calendar.current.component(.day, from: Date()) && month == dateFormatter.string(from: Date())) {
                model.isSelected = true
            }
            let todayDate = Calendar.current.component(.day, from: Date())
            let todayMonth = dateFormatter.string(from: Date())
            self.selectedDate = todayMonth + " " + "\(todayDate)"
            self.listOfDates.append(model)
        }
    }
    
}

extension Date {
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
