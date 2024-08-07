//
//  CreateNewCategoryCell.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 04.07.2024.
//

import UIKit

final class CreateNewCategoryCell: UICollectionViewCell {
    
    // MARK: Public Properties
    static let newCategoryIdentifier = "newCategoryCell"
    
    weak var weekDaysDelegate: SelectedWeekDaysDelegate?
    weak var navigationController: UINavigationController?
    
    var selectedWeekDays = [WeekDay]()
    var selectedCategory = ""
        
    var typeTracker: TypeTracker?
        
    // MARK: Private Properties
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypGray
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.cornerRadius = 16
        tableView.frame = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellNewTracker")
        return tableView
    }()
    
    // MARK: Override Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CreateNewCategoryCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if typeTracker == .habit {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellNewTracker")
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypLightGray
        cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = .ypGray
        
        guard let typeTracker = typeTracker else { return UITableViewCell() }
        
        let section = SectionTable(rawValue: indexPath.row)
        
        if typeTracker == .habit {
            switch section {
            case .category:
                cell.detailTextLabel?.text = selectedCategory
                cell.textLabel?.text = "Категория"
            case .schedule:
                cell.textLabel?.text = "Расписание"
                if selectedWeekDays.count == 7 {
                    cell.detailTextLabel?.text = "Каждый день"
                } else {
                    cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                    
                    let selectedDaysText = selectedWeekDays.map { $0.rawValue }.joined(separator: ", ")
                    cell.detailTextLabel?.text = selectedDaysText
                }
            default:
                return UITableViewCell()
            }
        } else {
            cell.textLabel?.text = "Категория"
            cell.layer.cornerRadius = 16
            cell.detailTextLabel?.text = selectedCategory
        }
        return cell
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = SectionTable(rawValue: indexPath.row)
        switch section {
        case .category:
            let categoryViewController = CategoryViewController()
            categoryViewController.categoryDelegate = self
            navigationController?.pushViewController(categoryViewController, animated: true)
        case .schedule:
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.scheduleDelegate = self
            navigationController?.pushViewController(scheduleViewController, animated: true)
        case .none:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - ScheduleViewControllerDelegate
extension CreateNewCategoryCell: ScheduleViewControllerDelegate {
    func sendSelectedDays(selectedDays: [WeekDay]) {
        self.selectedWeekDays = selectedDays

        weekDaysDelegate?.sendSelectedWeekDays(selectedDays)

        if selectedDays.count == 7 {
            tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text = "Каждый день"
        } else {
            let selectedDaysText = selectedDays.map { $0.rawValue }.joined(separator: ", ")
            tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text = selectedDaysText
        }
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
    }
}

// MARK: - CategoryViewControllerDelegate
extension CreateNewCategoryCell: CategoryViewControllerDelegate {
    func sendSelectedCategory(selectedCategory: String) {
        self.selectedCategory = selectedCategory
        tableView.reloadData()
    }
}
