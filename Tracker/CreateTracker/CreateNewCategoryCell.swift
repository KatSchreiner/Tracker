//
//  CreateNewCategoryCell.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 04.07.2024.
//

import UIKit

enum TypeTracker {
    case habit
    case event
}

final class CreateNewCategoryCell: UICollectionViewCell {
    static let newCategoryIdentifier = "newCategoryCell"
    
    var selectedDays: [WeekDay] = []
    var selectedCategory = ""
    
    var cellTitles = ["Категория", "Расписание"]
    
    var typeTracker: TypeTracker?
    
    weak var navigationController: UINavigationController?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypGray
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.cornerRadius = 16
        tableView.frame = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellNewTracker")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
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
        
        let titleCell = "\(cellTitles[indexPath.row])"
        cell.textLabel?.text = titleCell
        cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cell.detailTextLabel?.textColor = .ypGray
        
        if typeTracker == .habit {
            switch titleCell {
                
            case "Категория":
                cell.detailTextLabel?.text = selectedCategory
            case "Расписание":
                let selectedDaysText = selectedDays.map { $0.rawValue }.joined(separator: ", ")
                cell.detailTextLabel?.text = selectedDaysText
                
            default:
                break
            }
        } else if typeTracker == .event {
            cellTitles = ["Категория"]
            cell.layer.cornerRadius = 16
            cell.detailTextLabel?.text = selectedCategory
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = cellTitles[indexPath.row]
        
        switch title {
        case "Категория":
            let categoryViewController = CategoryViewController()
            categoryViewController.categoryDelegate = self
            categoryViewController.typeTracker = typeTracker
            navigationController?.pushViewController(categoryViewController, animated: true)
        case "Расписание":
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.scheduleDelegate = self
            navigationController?.pushViewController(scheduleViewController, animated: true)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - ScheduleViewControllerDelegate
extension CreateNewCategoryCell: ScheduleViewControllerDelegate {
    func sendSelectedDays(selectedDays: [WeekDay]) {
        self.selectedDays = selectedDays
        tableView.reloadData()
    }
}

// MARK: - CategoryViewControllerDelegate
extension CreateNewCategoryCell: CategoryViewControllerDelegate {
    func sendSelectedCategory(selectedCategory: String) {
        self.selectedCategory = selectedCategory
        tableView.reloadData()
    }
}
