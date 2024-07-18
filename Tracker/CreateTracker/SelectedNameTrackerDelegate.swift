//
//  SendCategoryNameTracker.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 17.07.2024.
//

import Foundation

protocol SelectedNameTrackerDelegate: AnyObject {
    func sendSelectedNameTracker(text: String)
}
