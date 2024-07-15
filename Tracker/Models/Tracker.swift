//
//  Tracker.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 23.06.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
    let typeTracker: TypeTracker
    
    init(id: UUID, name: String, color: UIColor, emoji: String, schedule: [WeekDay], typeTracker: TypeTracker) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.typeTracker = typeTracker
    }
}
