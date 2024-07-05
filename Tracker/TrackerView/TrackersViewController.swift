//
//  ViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 20.06.2024.
//
import UIKit

class TrackersViewController: UIViewController {
    
    // MARK: - Public Properties
    var trackers: [Tracker] = []
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
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
        datePicker.datePickerMode = .date
        let currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
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
        return labelIfNotFoundTrackers
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.trackerCell)
        collectionView.register(HeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionViewCell.headerIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollection()
    }
    
    // MARK: - IBAction
    @objc func didTapAddTracker() {
        let selectTypeTracker = SelectTypeTrackerViewController()
        let navigationController = UINavigationController(rootViewController: selectTypeTracker)
        present(navigationController,animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    // MARK: - Private Methods
    private func ifTrackerEmpty() {
        if trackers.isEmpty {
            placeholderForTrackers.isHidden = false
            labelIfNotFoundTrackers.isHidden = false
        } else {
            placeholderForTrackers.isHidden = true
            placeholderForTrackers.isHidden = true
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        [addButton, datePicker, titleTracker, searchBar, collectionView, placeholderForTrackers, labelIfNotFoundTrackers].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)

        addConstraintNavigationBar()

        setupPlaceholderForTrackers()
        setupLabelIfNotFoundTrackers()
    }
    
    private func addConstraintNavigationBar() {
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTracker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleTracker.topAnchor.constraint(equalTo: addButton.topAnchor, constant: 25),
            searchBar.topAnchor.constraint(equalToSystemSpacingBelow: titleTracker.bottomAnchor, multiplier: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
        
    }
    
    private func setupCollection() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupPlaceholderForTrackers() {
        NSLayoutConstraint.activate([
            placeholderForTrackers.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderForTrackers.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderForTrackers.widthAnchor.constraint(equalToConstant: 80),
            placeholderForTrackers.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupLabelIfNotFoundTrackers() {
        labelIfNotFoundTrackers.text = "Что будем отслеживать?"
        labelIfNotFoundTrackers.font = UIFont.systemFont(ofSize: 12)
        
        NSLayoutConstraint.activate([
            labelIfNotFoundTrackers.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            labelIfNotFoundTrackers.topAnchor.constraint(equalTo: placeholderForTrackers.bottomAnchor, constant: 10)
        ])
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.trackerCell, for: indexPath) as! TrackerCollectionViewCell
        
        cell.titleLabelCell.text = "Title"
        cell.emojiLabelCell.text = "❤️"
        cell.daysCountLabelCell.text = "1 день"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionViewCell.headerIdentifier, for: indexPath) as! HeaderCollectionViewCell
        
        headerView.titleLabelCell.text = "Заголовок"
        
        return headerView
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    
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
