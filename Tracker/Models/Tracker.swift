//
//  Tracker.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 23.06.2024.
//

import Foundation

struct Tracker {
    let id: Int
    let name: String
    let color: String
    let emoji: String
    let schedule: [(day: String, timeSlots: [TimeInterval])]
}
