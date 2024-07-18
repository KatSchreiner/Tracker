//
//  ConfigureTypeTrackerDelegate.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 17.07.2024.
//

import Foundation

protocol ConfigureTypeTrackerDelegate: AnyObject {
    func selectTypeTracker(cell: CreateNewCategoryCell)
    func calculateTableHeight(width: CGFloat) -> CGSize
}
