//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 23.06.2024.
//

import Foundation

struct TrackerRecord {
    let trackerId: UInt
    let date: String
    
    init(trackerId: UInt, date: String) {
        self.trackerId = trackerId
        self.date = date
    }
}
