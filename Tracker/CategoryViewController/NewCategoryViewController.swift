//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 08.08.2024.
//

import UIKit

protocol NewCategoryDelegate: AnyObject {
    func sendNewCategory(text: String)
}

final class NewCategoryViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: NewCategoryDelegate?
    
    // MARK: - Private Properties
    private let reuseIdentifier = "cellNewCategory"
    private let categoryStore = TrackerCategoryStore()
    
    private lazy var categoryTextField: UITextField = {
        let categoryTextField = UITextField()
        let textPadding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: categoryTextField.frame.height))
        categoryTextField.leftView = textPadding
        categoryTextField.leftViewMode = .always
        categoryTextField.textAlignment = .left
        categoryTextField.backgroundColor = .ypLightGray
        categoryTextField.placeholder = "category_name".localized()
        categoryTextField.clearButtonMode = .whileEditing
        categoryTextField.layer.cornerRadius = 16
        categoryTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        return categoryTextField
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .custom)
        doneButton.backgroundColor = .ypWhiteNight
        doneButton.setTitle("done".localized(), for: .normal)
        doneButton.setTitleColor(.ypWhiteDay, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        doneButton.layer.cornerRadius = 16
        doneButton.addTarget(self, action: #selector(didTapSaveCategory), for: .touchUpInside)
        return doneButton
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - IBAction
    @objc private func didTapSaveCategory() {
        guard let text = categoryTextField.text, !text.isEmpty else { return }
        delegate?.sendNewCategory(text: categoryTextField.text ?? "")
        try? categoryStore.saveCategoryToCoreData(title: text)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard let text = categoryTextField.text else { return }
        
        if text.isEmpty {
            doneButton.isEnabled = false
            doneButton.backgroundColor = .ypWhiteDay
        } else {
            doneButton.isEnabled = true
            doneButton.backgroundColor = .ypWhiteNight
        }
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .ypWhiteDay
        navigationItem.hidesBackButton = true
        title = "category".localized()
        
        [categoryTextField, doneButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        addConstraint()
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            categoryTextField.heightAnchor.constraint(equalToConstant: 75),
            categoryTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
