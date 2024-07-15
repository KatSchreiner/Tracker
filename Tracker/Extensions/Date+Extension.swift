//
//  Date.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 10.07.2024.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: self)
    }
    
    func dayOfWeek() -> Int {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: self)
    }
}
