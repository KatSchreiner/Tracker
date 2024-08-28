import UIKit

class TrackersViewController: UIViewController {
    
    // MARK: - Public Properties
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date = Date()
    lazy var currentCategories: [TrackerCategory] = {
        showTrackersInCurrentDate()
    }()
    
    var pinnedTrackers: Set<UUID> = []
    
    var selectedFilter: TrackerFilter? {
        didSet {
            updateColorTextFilterButton()
            saveSelectedFilter()
        }
    }
    
    // MARK: - Private Properties
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private var isSearching: Bool = false
    private var isFiltering: Bool = false
    
    private var analyticsService = AnalyticsService.shared
    
    private let bottomInset: CGFloat = 70
    
    private lazy var addButton: UIBarButtonItem = {
        let image = UIImage(named: "plus")
        let addButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTapAddTracker))
        addButton.tintColor = .yBlack
        return addButton
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = .current
        datePicker.calendar = .current
        datePicker.calendar.firstWeekday = 2
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        datePicker.setValue(UIColor.black, forKey: "textColor")
        
        if let datePickerSubView = datePicker.subviews.first {
            for subView in datePickerSubView.subviews {
                subView.backgroundColor = .yLightGray
            }
        }
        
        datePicker.overrideUserInterfaceStyle = .light
        
        return datePicker
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.placeholder = "search".localized()
        return searchController
    }()
    
    private lazy var placeholderForTrackers: UIImageView = {
        let notFoundTrackers = UIImage(named: "not_found_trackers")
        let placeholderForTrackers = UIImageView(image: notFoundTrackers)
        return placeholderForTrackers
    }()
    
    private lazy var labelIfNotFoundTrackers: UILabel = {
        let labelIfNotFoundTrackers = UILabel()
        labelIfNotFoundTrackers.text = "what_track".localized()
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
        collectionView.backgroundColor = .yWhite
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        return collectionView
    }()
    
    private lazy var placeholderForSearch: UIImageView = {
        let searchForTrackers = UIImage(named: "search_not_found")
        let placeholderForSearch = UIImageView(image: searchForTrackers)
        return placeholderForSearch
    }()
    
    private lazy var labelIfSearchNotFound: UILabel = {
        let labelIfSearchNotFound = UILabel()
        labelIfSearchNotFound.text = "nothing_found".localized()
        labelIfSearchNotFound.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return labelIfSearchNotFound
    }()
    
    private lazy var filterButton: UIButton = {
        let filterButton = UIButton(type: .custom)
        filterButton.setTitle("filters".localized(), for: .normal)
        filterButton.setTitleColor(.white, for: .normal)
        filterButton.backgroundColor = .yBlue
        filterButton.layer.cornerRadius = 16
        filterButton.layer.masksToBounds = true
        filterButton.addTarget(self, action: #selector(didTapFilterTrackers), for: .touchUpInside)
        return filterButton
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
        
        loadCoreData()
        loadSelectedFilter()
        
        analyticsService.report(event: "open", screen: "Main")
    }
    
    // MARK: - IBAction
    @objc func didTapAddTracker() {
        let selectTypeTracker = SelectTypeTrackerViewController()
        selectTypeTracker.delegate = self
        let navigationController = UINavigationController(rootViewController: selectTypeTracker)
        present(navigationController,animated: true)
        
        analyticsService.report(event: "click", screen: "Main", item: "add_track")
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        
        if let selectedFilter = selectedFilter {
            didSelectFilter(selectedFilter)
        } else {
            currentCategories = showTrackersInCurrentDate()
            updateCollection()
        }
    }
    
    @objc func didTapFilterTrackers() {
        let filterTrackers = FilterTrackersViewController()
        filterTrackers.selectedFilter = self.selectedFilter
        filterTrackers.delegate = self
        let navigationFilterTrackers = UINavigationController(rootViewController: filterTrackers)
        present(navigationFilterTrackers, animated: true)
        
        analyticsService.report(event: "click", screen: "Main", item: "filter")
    }
    
    // MARK: - Private Methods
    private func loadCoreData() {
        print("Loading Core Data")

        categories = trackerCategoryStore.categories
        completedTrackers = trackerRecordStore.trackerRecord
        
        print("Categories loaded: \(categories.count)")
        print("Completed trackers loaded: \(completedTrackers.count)")

        if let selectedFilter = selectedFilter {
            didSelectFilter(selectedFilter)
        } else {
            updateCollection()
        }
    }
    
    private func setupNavigation() {
        title = "trackers".localized()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        navigationItem.searchController = searchController
    }
    private func setupView() {
        view.backgroundColor = .yWhite
        [datePicker, collectionView, placeholderForTrackers, labelIfNotFoundTrackers, placeholderForSearch, labelIfSearchNotFound, filterButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        addConstraint()
        
        updateTrackersPlaceholderVisibility()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
            labelIfSearchNotFound.topAnchor.constraint(equalTo: placeholderForSearch.bottomAnchor, constant: 10),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func updateFilterButtonVisibility() {
        filterButton.isHidden = currentCategories.isEmpty
    }
    
    private func updateColorTextFilterButton() {
        if selectedFilter == .allTrackers {
            filterButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            filterButton.setTitleColor(.yRed, for: .normal)
        }
    }
    
    private func saveSelectedFilter() {
        guard let filter = selectedFilter else {
            UserDefaults.standard.removeObject(forKey: "SelectedFilter")
            return
        }
        UserDefaults.standard.set(filter.rawValue, forKey: "selectedFilter")
    }
    
    private func loadSelectedFilter() {
        let filterValue = UserDefaults.standard.integer(forKey: "selectedFilter")
        if let filter = TrackerFilter(rawValue: filterValue) {
            selectedFilter = filter
            didSelectFilter(filter)
        }
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
        updateFilterButtonVisibility()
        updateTrackersPlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility(setHidden: Bool) {
        placeholderForTrackers.isHidden = setHidden
        labelIfNotFoundTrackers.isHidden = setHidden
    }
    
    private func updatePlaceholderVisibilityForSearch(setHidden: Bool) {
        placeholderForSearch.isHidden = setHidden
        labelIfSearchNotFound.isHidden = setHidden
    }
    
    private func updateTrackersPlaceholderVisibility() {
        if categories.isEmpty {
            updatePlaceholderVisibility(setHidden: false)
            updatePlaceholderVisibilityForSearch(setHidden: true)
        } else {
            updatePlaceholderVisibility(setHidden: true)
        }
    }
    
    private func updateSearchPlaceholderVisibility() {
        if isSearching && currentCategories.isEmpty {
            updatePlaceholderVisibility(setHidden: true)
            updatePlaceholderVisibilityForSearch(setHidden: false)
        } else {
            updatePlaceholderVisibilityForSearch(setHidden: true)
        }
    }
    
    private func updateFilterPlaceholderVisibility() {
        if isFiltering && currentCategories.isEmpty {
            updatePlaceholderVisibility(setHidden: true)
            updatePlaceholderVisibilityForSearch(setHidden: false)
        } else {
            updatePlaceholderVisibilityForSearch(setHidden: true)
        }
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
        
        analyticsService.report(event: "click", screen: "Main", item: "track")
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
        if currentCategories.isEmpty {
            updatePlaceholderVisibility(setHidden: false)
            updateTrackersPlaceholderVisibility()
            return 0
        } else {
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
            
            let pinAction = UIAction(title: isPinned ? "Unpin".localized() : "Pin".localized()) { action in
                
                if isPinned {
                    self.unpinTracker(indexPath: indexPath[0])
                } else {
                    self.pinTracker(indexPath: indexPath[0])
                }
                
                self.updateCollection()
            }
            
            let editAction = UIAction(title: "Edit".localized(), identifier: nil, discoverabilityTitle: nil, state: .off) { action in
                self.editTracker(tracker: tracker, completedDays: self.completedTrackers.filter { $0.trackerId == tracker.id }.count)
            }
            
            let deleteAction = UIAction(title: "Delete".localized(), attributes: .destructive) { action in
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
    
    private func editTracker(tracker: Tracker, completedDays: Int) {
        let createNewTrackerVC = EditTrackerViewController()
        createNewTrackerVC.createTrackerDelegate = self
        
        if let category = currentCategories.first(where: { $0.trackers.contains(where: { $0.id == tracker.id }) })?.title {
            createNewTrackerVC.getDataForEdit(tracker: tracker, completedDays: completedDays, category: category)
        } else {
            createNewTrackerVC.getDataForEdit(tracker: tracker, completedDays: completedDays, category: "")
        }
        
        let navigationController = UINavigationController(rootViewController: createNewTrackerVC)
        present(navigationController, animated: true, completion: nil)
        
        analyticsService.report(event: "click", screen: "Main", item: "edit")
    }
    
    private func deleteTracker(indexPath: IndexPath) {
        let trackerToDelete = currentCategories[indexPath.section].trackers[indexPath.row].id
        
        try? trackerStore.deleteTrackerFromCoreData(id: trackerToDelete)
        
        loadCoreData()
        updateCollection()
        
        analyticsService.report(event: "click", screen: "Main", item: "delete")
    }
    
    private func showDeleteConfirmationAlert(indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "del_tracker".localized(),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(
            title: "Delete".localized(),
            style: .destructive) { [weak self] _ in
                self?.deleteTracker(indexPath: indexPath)
            }
        
        let cancelAction = UIAlertAction(
            title: "cancel".localized(),
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
    
    func updateTracker(tracker: Tracker, category: String) {
        try? trackerStore.updateTracker(tracker, category)
        updateCategories(with: tracker, in: category, isNew: false)
    }
    
    func createTracker(tracker: Tracker, category: String) {
        try? trackerStore.saveTrackerToCoreData(tracker: tracker, category: category)
        updateCategories(with: tracker, in: category, isNew: true)
    }
    
    private func updateCategories(with tracker: Tracker, in category: String, isNew: Bool) {
        var updatedCategories = categories

        for (index, existingCategory) in updatedCategories.enumerated() {
            if let trackerIndex = existingCategory.trackers.firstIndex(where: { $0.id == tracker.id }) {
                var updatedTrackers = existingCategory.trackers
                updatedTrackers.remove(at: trackerIndex)
                updatedCategories[index] = TrackerCategory(title: existingCategory.title, trackers: updatedTrackers)
                break
            }
        }
        
        if let existingCategoryIndex = updatedCategories.firstIndex(where: { $0.title == category }) {
            var trackers = updatedCategories[existingCategoryIndex].trackers
            if isNew {
                trackers.append(tracker)
            } else {
                if let trackerIndex = trackers.firstIndex(where: { $0.id == tracker.id }) {
                    trackers[trackerIndex] = tracker
                } else {
                    trackers.append(tracker)
                }
            }
            updatedCategories[existingCategoryIndex] = TrackerCategory(title: category, trackers: trackers)
        } else {
            let newCategory = TrackerCategory(title: category, trackers: [tracker])
            updatedCategories.append(newCategory)
        }
        
        categories = updatedCategories
        
        updateCollection()
        updatePlaceholderVisibility(setHidden: !categories.isEmpty)
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
        
        updateSearchPlaceholderVisibility()
        
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

// MARK: - FilterTrackersDelegate
extension TrackersViewController: FilterTrackersDelegate {
    func log(_ message: String) {
        print("[TrackersViewController] \(message)")
    }
    
    func didSelectFilter(_ filter: TrackerFilter) {
        log("Фильтр выбран: \(filter)")
        
        isFiltering = true
        selectedFilter = filter
        
        switch filter {
        case .allTrackers:
            currentCategories = showTrackersInCurrentDate()
            log("Показ всех трекеров.")
            
        case .trackersToday:
            currentDate = Date()
            datePicker.date = currentDate
            currentCategories = showTrackersInCurrentDate()
            log("Показ трекеров на сегодня.")
            
        case .completed:
            currentCategories = showCompletedTrackers()
            log("Показ выполненных трекеров.")
            
        case .uncompleted:
            currentCategories = showUncompletedTrackers()
            log("Показ невыполненных трекеров.")
        }
        
        updateFilterPlaceholderVisibility()
        
        collectionView.reloadData()
        
        isFiltering = false
    }
    
    private func showCompletedTrackers() -> [TrackerCategory] {
        let result = categories.compactMap { category in
            let completedTrackersForDate = completedTrackers
                .filter { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
                .map { $0.trackerId }
            
            let trackers = category.trackers.filter { completedTrackersForDate.contains($0.id) }
            if trackers.isEmpty { log("Нет выполненных трекеров в категории \(category.title).") }
            return trackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: trackers)
        }
        
        return result
    }
    
    private func showUncompletedTrackers() -> [TrackerCategory] {
        let result = categories.compactMap { category in
            let completedTrackersForDate = completedTrackers
                .filter { Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
                .map { $0.trackerId }
            
            let trackers = category.trackers.filter { !completedTrackersForDate.contains($0.id) }
            if trackers.isEmpty { log("Нет невыполненных трекеров в категории \(category.title).") }
            
            return trackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: trackers)
        }
        
        return result
    }
}

// MARK: - TrackerStoreDelegate
extension TrackersViewController: TrackerStoreDelegate {
    func trackerStoreDidChange(_ store: TrackerStore) {
        categories = trackerCategoryStore.categories
        collectionView.reloadData()
    }
}

// MARK: - TrackerRecordStoreDelegate
extension TrackersViewController: TrackerRecordStoreDelegate {
    func recordDidChange() {
        completedTrackers = trackerRecordStore.trackerRecord
    }
}
