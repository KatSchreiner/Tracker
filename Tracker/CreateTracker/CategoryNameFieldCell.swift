//
//  CategoryNameFieldCell.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 04.07.2024.
//

import UIKit

protocol SaveCategoryNameTracker: AnyObject {
    func addNewNametracker(text: String)
}

final class CategoryNameFieldCell: UICollectionViewCell {
    static let nameFieldIdentifier = "nameFieldCell"
    
    weak var newNameTrackerDelegate: SaveCategoryNameTracker?

    lazy var textFieldNameTracker: UITextField = {
        let textFieldNameTracker = UITextField()
        textFieldNameTracker.placeholder = "Введите название категории"
        textFieldNameTracker.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textFieldNameTracker.textAlignment = .center
        textFieldNameTracker.textColor = .ypGray
        textFieldNameTracker.backgroundColor = .ypLightGray
        textFieldNameTracker.layer.cornerRadius = 16
        textFieldNameTracker.rightView = clearButton
        textFieldNameTracker.rightViewMode = .whileEditing
        textFieldNameTracker.addTarget(self, action: #selector(NameTrackerDidChange), for: .editingDidEnd)
        return textFieldNameTracker
    }()
    
    private lazy var clearButton: UIButton = {
        let clearButton = UIButton()
        let image = UIImage(named: "clear_text")
        clearButton.setImage(image, for: .normal)
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        return clearButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func NameTrackerDidChange() {
        guard let text = textFieldNameTracker.text else { return }
        newNameTrackerDelegate?.addNewNametracker(text: text)
    }
    
    @objc private func clearText() {
        textFieldNameTracker.text = ""
    }
    
    private func setupView() {
        contentView.addSubview(textFieldNameTracker)
        textFieldNameTracker.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textFieldNameTracker.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            textFieldNameTracker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textFieldNameTracker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textFieldNameTracker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
