//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 25.06.2024.
//

import UIKit

final class CreateNewEventViewController: CreateNewTrackerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Новое нерегулярное событие"
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
    }
    
    @objc override func didTapCreateButton() {
        guard 
            let name = trackerName,
            let emoji = selectedEmoji,
            let color = selectedColor
        else { return }
        
        let tracker = Tracker(
            id: UUID(), 
            name: name,
            color: color,
            emoji: emoji,
            schedule: trackerSelectedWeekDays, 
            typeTracker: .event
        )
        
        createTrackerDelegate?.createTracker(tracker: tracker, category: trackerCategory)
        
        self.dismiss(animated: true, completion: nil)
    }
}
