import Foundation

final class EditTrackerViewController: CreateNewHabitViewController {
    private var id: UUID?
    private var type: TypeTracker = .habit
    private var trackerStore = TrackerStore()
    private var tracker: Tracker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        if isEdit {
            configureForEditing()
        }
    }
    
    override func setupView() {
        super.setupView()
        
        createButton.isEnabled = true
        createButton.backgroundColor = .yBlack
        createButton.setTitle("Сохранить", for: .normal)
        
        title = "Редактирование привычки"
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
    }
    
    override func didTapCreateButton() {
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
            typeTracker: type,
            isPinned: false
        )
        
        if isEdit {
            do {
                try trackerStore.updateTracker(tracker, category: selectedCategory)
                print("Трекер обновлен: \(tracker)")
            } catch {
                print("Ошибка обновления трекера: \(error)")
            }
        } else {
            createTrackerDelegate?.createTracker(tracker: tracker, category: selectedCategory)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureForEditing() {
        guard let tracker = self.tracker else { return }
        
        trackerName = tracker.name
        selectedColor = tracker.color
        selectedEmoji = tracker.emoji
        trackerSelectedWeekDays = tracker.schedule
        type = tracker.typeTracker
        
        createButton.setTitle("Сохранить", for: .normal)
        title = tracker.typeTracker == .habit ? "Редактирование привычки" : "Редактирование события"
    }
    
    func getDataForEdit(tracker: Tracker) {
        isEdit = true
        
        self.tracker = tracker
        configureForEditing()
    }
}
