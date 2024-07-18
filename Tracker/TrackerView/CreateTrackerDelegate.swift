//
//  CreateTrackerDelegate.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 17.07.2024.
//

import Foundation

protocol CreateTrackerDelegate: AnyObject {
    func createTracker(tracker: Tracker, category: String)
}
