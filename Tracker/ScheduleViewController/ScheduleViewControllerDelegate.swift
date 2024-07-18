//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 17.07.2024.
//

import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func sendSelectedDays(selectedDays: [WeekDay])
}
