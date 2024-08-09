//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 08.08.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func sendSelectedCategory(selectedCategory: String)
}

final class CategoriesViewController: UIViewController {
    // MARK: - Public Properties
    weak var categoryDelegate: CategoryViewControllerDelegate?
    
    // MARK: - Private Properties
    private let viewModel = CategoriesViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        return tableView
    }()
    
    private lazy var addNewCategoryButton: UIButton = {
        let addNewCategoryButton = UIButton(type: .custom)
        addNewCategoryButton.setTitle("Добавить категорию", for: .normal)
        addNewCategoryButton.setTitleColor(.ypWhiteDay, for: .normal)
        addNewCategoryButton.backgroundColor = .ypWhiteNight
        addNewCategoryButton.layer.cornerRadius = 16
        addNewCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addNewCategoryButton.addTarget(self, action: #selector(didTapAddCategory), for: .touchUpInside)
        return addNewCategoryButton
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно объединить по смыслу"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypWhiteNight
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let placeholderImage = UIImageView()
        placeholderImage.image = UIImage(named: "not_found_trackers")
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        return placeholderImage
    }()
    
    private lazy var placeholderStackView: UIStackView = {
        let placeholderStackView = UIStackView(arrangedSubviews: [placeholderImage, label])
        placeholderStackView.axis = .vertical
        placeholderStackView.alignment = .center
        placeholderStackView.spacing = 8
        placeholderStackView.isHidden = true
        return placeholderStackView
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
        viewModel.viewDidLoad()
    }
    
    // MARK: - IBAction
    @objc
    private func didTapAddCategory() {
        let newCategory = NewCategoryViewController()
        newCategory.delegate = self
        navigationController?.pushViewController(newCategory, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .ypWhiteDay
        navigationItem.hidesBackButton = true
        title = "Категория"
        
        [tableView, addNewCategoryButton, placeholderStackView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        addConstraint()
    }
    
    private func setupBindings() {
        viewModel.onCategoriesChanged = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onPlaceholderStateChanged = { [weak self] showPlaceholder in
            self?.tableView.isHidden = showPlaceholder
            self?.placeholderStackView.isHidden = !showPlaceholder
            
        }
    }
    
    private func showPlaceholder() {
        let hasCategories = viewModel.numberOfCategories > 0
        tableView.isHidden = !hasCategories
        placeholderStackView.isHidden = hasCategories
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: addNewCategoryButton.topAnchor, constant: -16),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeholderStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addNewCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            addNewCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            addNewCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addNewCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

//MARK: - UITableViewDataSource
extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCategories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        
        cell.textLabel?.text = viewModel.category(at: indexPath.row)
        cell.selectionStyle = .none
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        let selectedCategory = viewModel.category(at: indexPath.row)
        categoryDelegate?.sendSelectedCategory(selectedCategory: selectedCategory)
        
        print("[CategoriesViewController: UITableViewDelegate] - Выбранная категория: \(selectedCategory)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        
        if numberOfRows > 0 {
            if indexPath.row == 0 {
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                cell.layer.masksToBounds = true
            } else if indexPath.row == numberOfRows - 1 {
                cell.layer.cornerRadius = 16
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                cell.layer.masksToBounds = true
            } else {
                cell.layer.cornerRadius = 0
                cell.layer.masksToBounds = true
            }
        }
    }
}

//MARK: - NewCategoryDelegate
extension CategoriesViewController: NewCategoryDelegate {
    func sendNewCategory(text: String) {
        guard !text.isEmpty else { return }
        viewModel.addCategory(text)
    }
}
