//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 23.06.2024.
//

import Foundation

struct TrackerRecord {
    let trackerId: UUID
    let date: Date
    
    init(trackerId: UUID, date: Date) {
        self.trackerId = trackerId
        self.date = date
    }
}
