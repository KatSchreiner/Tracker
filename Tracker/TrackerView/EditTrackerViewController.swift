import UIKit

final class EditTrackerViewController: CreateNewHabitViewController {
    
    // MARK: - Private Properties
    private lazy var daysCountLabel: UILabel = {
        let daysCountLabel = UILabel()
        daysCountLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        daysCountLabel.textAlignment = .center
        return daysCountLabel
    }()
    
    private var id: UUID?
    private var collectionViewTopConstraint: NSLayoutConstraint!
    private var trackerStore: TrackerStore?
    private var isEdit = false
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - Overrides Methods
    override func setupView() {
        super.setupView()
        
        createButton.isEnabled = true
        createButton.backgroundColor = .yBlack
        createButton.setTitle("save".localized(), for: .normal)
        createButton.setTitleColor(.yWhite, for: .normal)
        
        title = "edit_habit".localized()
        view.backgroundColor = .yWhite
        navigationItem.hidesBackButton = true
        
        view.addSubview(daysCountLabel)
        daysCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: daysCountLabel.bottomAnchor, constant: 24)
        collectionViewTopConstraintDefault.isActive = false
        collectionViewTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            daysCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            daysCountLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            daysCountLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            daysCountLabel.heightAnchor.constraint(equalToConstant: 38),
            collectionViewTopConstraint
        ])
    }
    
    override func didTapCreateButton() {
        guard
            let name = trackerName,
            let emoji = selectedEmoji,
            let color = selectedColor,
            let id
        else { return }
        
        let tracker = Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: trackerSelectedWeekDays,
            typeTracker: .habit,
            isPinned: false
        )
                
        if isEdit {
            createTrackerDelegate?.updateTracker(tracker: tracker, category: selectedCategory)
            print("[EditTrackerViewController: didTapCreateButton] - Трекер обновлен: \(tracker)")
            try? trackerStore?.updateTracker(tracker, selectedCategory)
        } else {
            createTrackerDelegate?.createTracker(tracker: tracker, category: selectedCategory)
            try? trackerStore?.saveTrackerToCoreData(tracker: tracker, category: selectedCategory)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Public Methods
    func getDataForEdit(tracker: Tracker, completedDays: Int, category: String) {
        isEdit = true
                
        id = tracker.id
        trackerName = tracker.name
        selectedColor = tracker.color
        selectedEmoji = tracker.emoji
        trackerSelectedWeekDays = tracker.schedule
        selectedCategory = category 
        daysCountLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: "Number of remaining days"),
            completedDays
        )
        
        collectionView.reloadData()
        
        updateSelectedItems()
    }
    
    // MARK: - Private Methods
    private func updateSelectedItems() {
        collectionView.indexPathsForSelectedItems?.forEach { indexPath in
            collectionView.deselectItem(at: indexPath, animated: false)
        }

        if let selectedEmoji = selectedEmoji, let emojiIndex = emojies.firstIndex(of: selectedEmoji) {
            let indexPath = IndexPath(item: emojiIndex, section: SectionCollection.emoji.rawValue)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        }
        
        if let selectedColor = selectedColor, let colorIndex = colors.firstIndex(of: selectedColor) {
            let indexPath = IndexPath(item: colorIndex, section: SectionCollection.color.rawValue)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        }
    }
}
