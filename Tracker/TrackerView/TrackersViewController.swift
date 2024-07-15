//
//  ViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 20.06.2024.
//
import UIKit

class TrackersViewController: UIViewController {
    static let shared = TrackersViewController()
    
    // MARK: - Public Properties
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate: Date = Date()
    lazy var currentCategories: [TrackerCategory] = {
        showTrackersInCurrentDate()
    }()

    // MARK: - Private Properties
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
    
    private lazy var titleTracker: UILabel = {
        let titleTracker = UILabel()
        titleTracker.text = "Трекеры"
        titleTracker.textColor = .ypBlackDay
        titleTracker.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return titleTracker
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Поиск"
        return searchBar
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
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .white
        [addButton, datePicker, titleTracker, searchBar, collectionView, placeholderForTrackers, labelIfNotFoundTrackers].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)

        addConstraint()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            titleTracker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleTracker.topAnchor.constraint(equalTo: addButton.topAnchor, constant: 25),
            searchBar.topAnchor.constraint(equalToSystemSpacingBelow: titleTracker.bottomAnchor, multiplier: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholderForTrackers.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderForTrackers.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderForTrackers.widthAnchor.constraint(equalToConstant: 80),
            placeholderForTrackers.heightAnchor.constraint(equalToConstant: 80),
            labelIfNotFoundTrackers.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            labelIfNotFoundTrackers.topAnchor.constraint(equalTo: placeholderForTrackers.bottomAnchor, constant: 10)
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
}

extension TrackersViewController: TrackerCompletionDelegate {
    func didUpdateTrackerCompletion(trackerId: UUID, indexPath: IndexPath, isTrackerCompleted: Bool) {
        if currentDate > Date() {
              print("Вы не можете пометить трекер как выполненный на будущую дату")
              return
          }
        if isTrackerCompleted {
            completedTrackers.append(TrackerRecord(trackerId: trackerId, date: currentDate))
            collectionView.reloadData()
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
        if currentCategories.isEmpty {
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
        
        cell.delegate = self
        
        let isTrackerComplete = isTrackerComplete(trackerId: tracker.id)

        cell.configureAddButton(tracker: tracker, indexPath: indexPath, completedForCurrentDate: completedForCurrentDate, isTrackerCompleted: isTrackerComplete)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionViewCell.headerIdentifier, for: indexPath) as! HeaderCollectionViewCell
        
        headerView.titleLabelCell.text = categories[indexPath.section].title
        
        return headerView
    }
}

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

// MARK: - CreateTrackerDelegate
extension TrackersViewController: CreateTrackerDelegate {
    func createTracker(tracker: Tracker, category: String) {
        let category = category
        let categorySearch = categories.filter { $0.title == category }
        
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

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentCategories = []
        categories.forEach { category in
            let title = category.title
            let trackers = category.trackers.filter { tracker in
                return tracker.name.contains(searchText)
            }
            if !trackers.isEmpty {
                currentCategories.append(TrackerCategory(title: title, trackers: trackers))
            }
        }
        collectionView.reloadData()
    }
}
