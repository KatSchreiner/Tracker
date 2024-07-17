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
        
        self.delegate = self
    }
    
    @objc override func didTapCreateButton() {
        guard let name = trackerName, let emoji = selectedEmoji, let color = selectedColor  else { return }
        
        let weekDay = WeekDay.allCases
        let week = weekDay
        
        let tracker = Tracker(id: UUID(), name: name, color: color, emoji: emoji, schedule: weekDay, typeTracker: .event)
        
        print("Передаваемые данные:")
        print("Tracker ID: \(tracker.id)")
        print("Tracker Name: \(tracker.name)")
        print("Tracker Color: \(tracker.color)")
        print("Tracker Emoji: \(tracker.emoji)")
        print("Tracker Schedule: \(tracker.schedule)")
        print("Tracker Type: \(tracker.typeTracker)")
        
        createTrackerDelegate?.createTracker(tracker: tracker, category: trackerCategory)
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension CreateNewEventViewController: ConfigureTypeTrackerDelegate {
    func selectTypeTracker(cell: CreateNewCategoryCell) {
        print("SelectTypeTracker Event called!")
        cell.typeTracker = .event
    }
    
    func calculateTableHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 75)
    }
}
