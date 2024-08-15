import UIKit

class TrackersViewController: UIViewController {
    
    // MARK: - Public Properties
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date = Date()
    var isSearching: Bool = false
    lazy var currentCategories: [TrackerCategory] = {
        showTrackersInCurrentDate()
    }()
    
    var pinnedTrackers: Set<UUID> = []
    
    // MARK: - Private Properties
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton(type: .custom)
        let image = UIImage(named: "plus")
        addButton.setImage(image, for: .normal)
        addButton.addTarget(self, action: #selector(didTapAddTracker), for: .touchUpInside)
        addButton.tintColor = .ypBlackDay
        return addButton
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_Ru")
        datePicker.calendar.firstWeekday = 2
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.placeholder = "Поиск"
        return searchController
    }()
    
    private lazy var placeholderForTrackers: UIImageView = {
        let notFoundTrackers = UIImage(named: "not_found_trackers")
        let placeholderForTrackers = UIImageView(image: notFoundTrackers)
        return placeholderForTrackers
    }()
    
    private lazy var labelIfNotFoundTrackers: UILabel = {
        let labelIfNotFoundTrackers = UILabel()
        labelIfNotFoundTrackers.text = "Что будем отслеживать?"
        labelIfNotFoundTrackers.font = UIFont.systemFont(ofSize: 12)
        return labelIfNotFoundTrackers
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier)
        collectionView.register(HeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionViewCell.headerIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var placeholderForSearch: UIImageView = {
        let searchForTrackers = UIImage(named: "search_not_found")
        let placeholderForSearch = UIImageView(image: searchForTrackers)
        return placeholderForSearch
    }()
    
    private lazy var labelIfSearchNotFound: UILabel = {
        let labelIfSearchNotFound = UILabel()
        labelIfSearchNotFound.text = "Ничего не найдено"
        labelIfSearchNotFound.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return labelIfSearchNotFound
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
        
        loadCoreData()
    }
    
    // MARK: - IBAction
    @objc func didTapAddTracker() {
        let selectTypeTracker = SelectTypeTrackerViewController()
        selectTypeTracker.delegate = self
        let navigationController = UINavigationController(rootViewController: selectTypeTracker)
        present(navigationController,animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        currentDate = selectedDate
        currentCategories = showTrackersInCurrentDate()
        updateCollection()
        
    }
    
    // MARK: - Private Methods
    private func loadCoreData() {
        categories = trackerCategoryStore.categories
        completedTrackers = trackerRecordStore.trackerRecord
        
        updateCollection()
    }
    
    private func setupNavigation() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        navigationItem.searchController = searchController
    }
    private func setupView() {
        view.backgroundColor = .white
        [addButton, datePicker, collectionView, placeholderForTrackers, labelIfNotFoundTrackers, placeholderForSearch, labelIfSearchNotFound].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        addConstraint()
        
        updatePlaceholderVisibilityForSearch(setHidden: true)
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholderForTrackers.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderForTrackers.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderForTrackers.widthAnchor.constraint(equalToConstant: 80),
            placeholderForTrackers.heightAnchor.constraint(equalToConstant: 80),
            labelIfNotFoundTrackers.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            labelIfNotFoundTrackers.topAnchor.constraint(equalTo: placeholderForTrackers.bottomAnchor, constant: 10),
            placeholderForSearch.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderForSearch.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderForSearch.widthAnchor.constraint(equalToConstant: 80),
            placeholderForSearch.heightAnchor.constraint(equalToConstant: 80),
            labelIfSearchNotFound.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            labelIfSearchNotFound.topAnchor.constraint(equalTo: placeholderForSearch.bottomAnchor, constant: 10)
        ])
    }
    
    private func showTrackersInCurrentDate() -> [TrackerCategory] {
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        let stringWeekday: WeekDay = {
            switch weekday {
            case 1: return .sunday
            case 2: return .monday
            case 3: return .tuesday
            case 4: return .wednesday
            case 5: return .thursday
            case 6: return .friday
            default: return .saturday
            }
        }()
        
        return categories.compactMap { category in
            let trackers = category.trackers.filter { $0.schedule.contains(stringWeekday) }
            return trackers.count > 0 ? TrackerCategory(title: category.title, trackers: trackers) : nil
        }
    }
    
    private func updateCollection() {
        currentCategories = showTrackersInCurrentDate()
        collectionView.reloadData()
    }
    
    private func updatePlaceholderVisibility(setHidden: Bool) {
        placeholderForTrackers.isHidden = setHidden
        labelIfNotFoundTrackers.isHidden = setHidden
    }
    
    private func updatePlaceholderVisibilityForSearch(setHidden: Bool) {
        placeholderForSearch.isHidden = setHidden
        labelIfSearchNotFound.isHidden = setHidden
    }
}

// MARK: - TrackerCompletionDelegate
extension TrackersViewController: TrackerCompletionDelegate {
    func didUpdateTrackerCompletion(trackerId: UUID, indexPath: IndexPath, isTrackerCompleted: Bool) {
        if currentDate > Date() {
            print("Вы не можете пометить трекер как выполненный на будущую дату")
            return
        }
        if isTrackerCompleted {
            completedTrackers.append(TrackerRecord(trackerId: trackerId, date: currentDate))
            collectionView.reloadData()
            
            try? trackerRecordStore.addRecordToCompletedTrackers(trackerId: trackerId, date: currentDate)
            print("Трекер добавлен в completedTrackers: \(completedTrackers)")
            
        } else {
            completedTrackers = completedTrackers.filter {
                if $0.trackerId == trackerId && Calendar.current.isDate(
                    $0.date,
                    equalTo: currentDate,
                    toGranularity: .day
                ) {
                    return false
                }
                return true
            }
            
            try? trackerRecordStore.removeRecordFromCompletedTrackers(trackerId: trackerId, date: currentDate)
            
            print("Трекер удален из completedTrackers: \(completedTrackers)")
        }
        collectionView.reloadData()
    }
    
    private func isTrackerComplete(trackerId: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.trackerId == trackerId && isSameDay
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if currentCategories.isEmpty && !isSearching {
            updatePlaceholderVisibility(setHidden: false)
            return 0
        } else {
            updatePlaceholderVisibility(setHidden: true)
            return currentCategories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackers = currentCategories[section].trackers
        if trackers.isEmpty {
            updatePlaceholderVisibility(setHidden: false)
            return 0
        } else {
            updatePlaceholderVisibility(setHidden: true)
            return trackers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
        
        let tracker = currentCategories[indexPath.section].trackers[indexPath.row]
        let completedForCurrentDate = completedTrackers.filter { $0.trackerId == tracker.id }.count
        let typeTracker = tracker.typeTracker
        
        cell.delegate = self
        
        let isTrackerComplete = isTrackerComplete(trackerId: tracker.id)
        
        let isPinned = (try? trackerStore.fetchTrackerById(id: tracker.id))?.isPinned ?? false
        
        cell.configureAddButton(tracker: tracker, indexPath: indexPath, completedForCurrentDate: completedForCurrentDate, isTrackerCompleted: isTrackerComplete, typeTracker: typeTracker, isPinned: isPinned)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionViewCell.headerIdentifier, for: indexPath) as! HeaderCollectionViewCell
        
        headerView.titleLabelCell.text = categories[indexPath.section].title
        
        return headerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 16 * 2 - 9
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// MARK: ContextMENU - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
            return nil
        }
        let parameters = UIPreviewParameters()
        let previewView = UITargetedPreview(view: cell.bodyView, parameters: parameters)
        return previewView
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPath: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPath.count > 0 else { return nil }
        
        let tracker = currentCategories[indexPath[0].section].trackers[indexPath[0].row]
        
        return UIContextMenuConfiguration(actionProvider: { suggestedActions in
            let isPinned = self.pinnedTrackers.contains(tracker.id)
                        
            let pinAction = UIAction(title: isPinned ? "Открепить" : "Закрепить") { action in
                
                if isPinned {
                    self.unpinTracker(indexPath: indexPath[0])
                } else {
                    self.pinTracker(indexPath: indexPath[0])
                }
                
                self.updateCollection()
            }
            
            let editAction = UIAction(title: "Редактировать", identifier: nil, discoverabilityTitle: nil, state: .off) { action in
                self.editTracker(tracker: tracker)
            }
            
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { action in
                self.showDeleteConfirmationAlert(indexPath: indexPath[0])
            }
            
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
            
        })
    }
    
    private func pinTracker(indexPath: IndexPath) {
        let tracker = currentCategories[indexPath.section].trackers[indexPath.row]
        
        do {
            try trackerStore.pinTracker(id: tracker.id)
            pinnedTrackers.insert(tracker.id)
            updateCategoriesAfterPinning()
            updateCollection()
        } catch {
            print("Ошибка при закреплении трекера: \(error)")
        }
        
        print("Закреплен трекер с id: \(tracker.id)")
    }
    
    private func unpinTracker(indexPath: IndexPath) {
        let tracker = currentCategories[indexPath.section].trackers[indexPath.row]
        print("Пытаемся открепить трекер с id: \(tracker.id)")
        
        
        do {
            try trackerStore.unpinTracker(id: tracker.id)
            pinnedTrackers.remove(tracker.id)
            updateCategoriesAfterPinning()
            updateCollection()
            print("Трекер с id \(tracker.id) успешно откреплен")
        } catch {
            print("Ошибка при откреплении трекера: \(error)")
        }
    }
    
    private func editTracker(tracker: Tracker) {
        
        let createNewTrackerVC = EditTrackerViewController()
        createNewTrackerVC.createTrackerDelegate = self
        createNewTrackerVC.isEdit = true
        createNewTrackerVC.getDataForEdit(tracker: tracker)
        
        let navigationController = UINavigationController(rootViewController: createNewTrackerVC)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func deleteTracker(indexPath: IndexPath) {
        let trackerToDelete = currentCategories[indexPath.section].trackers[indexPath.row].id
        let categoryToDelete = currentCategories[indexPath.section].title
        let tracker = currentCategories[indexPath.section].trackers[indexPath.row]
        
        try? trackerStore.deleteTrackerFromCoreData(id: trackerToDelete)
        try?  trackerCategoryStore.deleteCategoryFromCoreData(title: categoryToDelete, tracker: tracker)
        
        loadCoreData()
        updateCollection()
    }
    
    private func showDeleteConfirmationAlert(indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "Уверены что хотите удалить трекер?",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(
            title: "Удалить",
            style: .destructive) { [weak self] _ in
                self?.deleteTracker(indexPath: indexPath)
            }
        
        let cancelAction = UIAlertAction(
            title: "Отменить",
            style: .cancel,
            handler: nil
        )
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    private func updateCategoriesAfterPinning() {
        currentCategories = showTrackersInCurrentDate()
    }
}

// MARK: - CreateTrackerDelegate
extension TrackersViewController: CreateTrackerDelegate {
    func createTracker(tracker: Tracker, category: String) {
        let category = category
        let categorySearch = categories.filter { $0.title == category }
        
        try? trackerStore.saveTrackerToCoreData(tracker: tracker, category: category)
        
        var trackers: [Tracker] = []
        if categorySearch.count > 0 {
            categorySearch.forEach { trackers = trackers + $0.trackers }
            trackers.append(tracker)
            
            categories = categories.filter { $0.title != category }
            
            if !trackers.isEmpty {
                categories.append(TrackerCategory(title: category, trackers: trackers))
            }
        } else {
            categories.append(TrackerCategory(title: category, trackers: [tracker]))
        }
                
        updateCollection()
        updatePlaceholderVisibility(setHidden: true)
    }
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        
        if isSearching {
            currentCategories = categories.compactMap { category in
                let filteredTrackers = category.trackers.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
            }
        } else {
            currentCategories = showTrackersInCurrentDate()
        }
        
        if currentCategories.isEmpty {
            updatePlaceholderVisibilityForSearch(setHidden: false)
        } else {
            updatePlaceholderVisibilityForSearch(setHidden: true)
        }
        
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        currentCategories = showTrackersInCurrentDate()
        collectionView.reloadData()
    }
}

//MARK: - TrackerStoreDelegate
extension TrackersViewController: TrackerStoreDelegate {
    func trackerStoreDidChange(_ store: TrackerStore) {
        categories = trackerCategoryStore.categories
        collectionView.reloadData()
    }
}

//MARK: - TrackerRecordStoreDelegate
extension TrackersViewController: TrackerRecordStoreDelegate {
    func recordDidChange() {
        completedTrackers = trackerRecordStore.trackerRecord
    }
}
