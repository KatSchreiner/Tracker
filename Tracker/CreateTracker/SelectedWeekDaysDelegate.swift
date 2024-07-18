//
//  SelectedWeekDaysDelegate.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 17.07.2024.
//

import Foundation

protocol SelectedWeekDaysDelegate: AnyObject {
    func sendSelectedWeekDays(_ selectedDays: [WeekDay])
}
