//
//  CreateNewTrackerViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 05.07.2024.
//

import UIKit

class CreateNewTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var createTrackerDelegate: CreateTrackerDelegate?
    weak var delegate: ConfigureTypeTrackerDelegate?
    
    var trackerSelectedWeekDays: [WeekDay] = []
    var trackerCategory = "Важное"
    var trackerName: String?
    var selectedEmoji: String?
    var selectedColor: UIColor?
    
    // MARK: - Private Properties
    private var emojies = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                           "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                           "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private let colors = [UIColor.ypColor1, .ypColor2, .ypColor3, .ypColor4, .ypColor5, .ypColor6,
                          .ypColor7, .ypColor8, .ypColor9, .ypColor10, .ypColor11, .ypColor12,
                          .ypColor13, .ypColor14, .ypColor15, .ypColor16, .ypColor17, .ypColor18]
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CategoryNameFieldCell.self, forCellWithReuseIdentifier: CategoryNameFieldCell.nameFieldIdentifier)
        collectionView.register(CreateNewCategoryCell.self, forCellWithReuseIdentifier: CreateNewCategoryCell.newCategoryIdentifier)
        collectionView.register(EmojiesCollectionViewCell.self, forCellWithReuseIdentifier: EmojiesCollectionViewCell.emojiIdentifier)
        collectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: ColorsCollectionViewCell.colorIdentifier)
        collectionView.register(HeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionViewCell.headerIdentifier)
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton(type: .custom)
        createButton.layer.cornerRadius = 16
        createButton.backgroundColor = .ypGray
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.ypWhiteDay, for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return createButton
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .custom)
        cancelButton.layer.cornerRadius = 16
        cancelButton.backgroundColor = .ypWhiteDay
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - IBAction
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func didTapCreateButton() {
        guard let name = trackerName, let emoji = selectedEmoji, let color = selectedColor else { return }
        
        let tracker = Tracker(id: UUID(), name: name, color: color, emoji: emoji, schedule: trackerSelectedWeekDays, typeTracker: .habit)
        
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
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .ypWhiteDay
                
        [createButton, cancelButton, stackView, collectionView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [stackView, collectionView].forEach { view in
            self.view.addSubview(view)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        addConstraintView()
        
        self.delegate = self as? ConfigureTypeTrackerDelegate

    }
    
    private func addConstraintView() {
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16)
        ])
    }
    
    private func changeColorButtonIfTrackerSuccess() {
        if let name = trackerName, let emoji = selectedEmoji, let color = selectedColor {
            createButton.backgroundColor = .ypWhiteNight
            createButton.isUserInteractionEnabled = true
        } else {
            createButton.backgroundColor = .ypGray
            createButton.isUserInteractionEnabled = false
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CreateNewTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionCollection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = SectionCollection(rawValue: section) else { return 0 }
        switch section {
        case .categoryNameField:
            return 1
        case .createNewCategory:
            return 1
        case .emoji:
            return emojies.count
        case .color:
            return colors.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let section = SectionCollection(rawValue: indexPath.section) else { fatalError("Invalid section")}
        
        switch section {
        case .categoryNameField:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryNameFieldCell.nameFieldIdentifier, for: indexPath) as! CategoryNameFieldCell
            cell.newNameTrackerDelegate = self
            return cell
        case .createNewCategory:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreateNewCategoryCell.newCategoryIdentifier, for: indexPath) as! CreateNewCategoryCell
            
            cell.weekDaysDelegate = self

            delegate?.selectTypeTracker(cell: cell)
            
            cell.navigationController = self.navigationController
            return cell
        case .emoji:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiesCollectionViewCell
            cell.prepareForReuse()
            cell.configure(emoji: emojies[indexPath.row])
            return cell
        case .color:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorsCollectionViewCell
            cell.prepareForReuse()
            cell.configure(color: colors[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionViewCell.headerIdentifier, for: indexPath) as! HeaderCollectionViewCell
            
            guard let section = SectionCollection(rawValue: indexPath.section) else { fatalError("Invalid section")}
            
            switch section {
            case .categoryNameField:
                headerView.titleLabelCell.text = ""
                return headerView
            case .createNewCategory:
                headerView.titleLabelCell.text = ""
                return headerView
            case .emoji:
                headerView.titleLabelCell.text = "Emoji"
                return headerView
            case .color:
                headerView.titleLabelCell.text = "Цвет"
                return headerView
            }
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate
extension CreateNewTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({ collectionView.deselectItem(at: $0, animated: false) })
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == SectionCollection.emoji.rawValue {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiesCollectionViewCell else {
                collectionView.deselectItem(at: indexPath, animated: true)
                return
            }
            if let emoji = cell.emojiLabel.text {
                selectedEmoji = emoji
            }
            
        } else if indexPath.section == SectionCollection.color.rawValue {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorsCollectionViewCell else {
                collectionView.deselectItem(at: indexPath, animated: true)
                return
            }
            if let color = cell.colorView.backgroundColor  {
                selectedColor = color
            }
        }
        changeColorButtonIfTrackerSuccess()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == SectionCollection.emoji.rawValue {
            selectedEmoji = nil
        } else if indexPath.section == SectionCollection.color.rawValue {
            selectedColor = nil
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CreateNewTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        guard let section = SectionCollection(rawValue: indexPath.section) else { fatalError("Invalid section")}
                
        switch section {
        case .categoryNameField:
            return CGSize(width: collectionView.bounds.width - 32, height: 75)
        case .createNewCategory:
            return delegate?.calculateTableHeight(width: collectionView.bounds.width - 32) ?? CGSize(width: collectionView.bounds.width - 32, height: 150)
        case .emoji:
            return CGSize(width: 52, height: 52)
        case .color:
            return CGSize(width: 52, height: 52)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard let section = SectionCollection(rawValue: section) else { fatalError("Invalid section")}
        
        switch section {
        case .categoryNameField:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .createNewCategory:
            return UIEdgeInsets(top: 10, left: 0, bottom: 30, right: 0)
        case .emoji:
            return UIEdgeInsets(top: 20, left: 16, bottom: 25, right: 16)
            
        case .color:
            return UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
}

extension CreateNewTrackerViewController: SelectedNameTrackerDelegate {
    func sendSelectedNameTracker(text: String) {
        trackerName = text
    }
}

extension CreateNewTrackerViewController: SelectedWeekDaysDelegate {
    func sendSelectedWeekDays(_ selectedDays: [WeekDay]) {
        trackerSelectedWeekDays = selectedDays
    } 
}

enum SectionCollection: Int, CaseIterable {
    case categoryNameField
    case createNewCategory
    case emoji
    case color
}
