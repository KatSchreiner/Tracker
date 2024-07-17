//
//  TrackerCompletionDelegate.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 17.07.2024.
//

import Foundation

protocol TrackerCompletionDelegate: AnyObject {
    func didUpdateTrackerCompletion(trackerId: UUID, indexPath: IndexPath, isTrackerCompleted: Bool)
}
