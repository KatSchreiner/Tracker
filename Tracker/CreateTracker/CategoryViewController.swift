//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 27.06.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func sendSelectedCategory(selectedCategory: String)
}

final class CategoryViewController: UIViewController {
    
    // MARK: - Private Properties
    private let reuseIdentifier = "cellNewCategory"
    var typeTracker: TypeTracker?
    weak var categoryDelegate: CategoryViewControllerDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .ypLightGray
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.cornerRadius = 16
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let addCategoryButton = UIButton(type: .custom)
        addCategoryButton.backgroundColor = .ypWhiteNight
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.setTitleColor(.ypWhiteDay, for: .normal)
        addCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategory), for: .touchUpInside)
        return addCategoryButton
    }()
        
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func didTapAddCategory() {
        navigationController?.popViewController(animated: true)
        categoryDelegate?.sendSelectedCategory(selectedCategory: "Важное" )
        switch typeTracker {
          case .habit:
              categoryDelegate?.sendSelectedCategory(selectedCategory: "Важное")
          case .event:
              categoryDelegate?.sendSelectedCategory(selectedCategory: "Важное")
          case .none:
              break
          }
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .ypWhiteDay
        title = "Категория"
        
        [tableView, addCategoryButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        addConstraintTableView()
        addConstraintCategoryButton()
    }
    
    private func addConstraintTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func addConstraintCategoryButton() {
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCategoryButton)
        
        NSLayoutConstraint.activate([
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        
        cell.textLabel?.text = "Важное"
        cell.backgroundColor = .ypLightGray
        cell.accessoryType = .none
        
        return cell
    }
}
