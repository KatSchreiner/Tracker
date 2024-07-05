//
//  CategoryNameFieldCell.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 04.07.2024.
//

import UIKit

final class CategoryNameFieldCell: UICollectionViewCell {
    static let nameFieldIdentifier = "nameFieldCell"

    private lazy var textFieldNameTracker: UITextField = {
        let textFieldNameTracker = UITextField()
        textFieldNameTracker.placeholder = "Введите название категории"
        textFieldNameTracker.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textFieldNameTracker.textAlignment = .center
        textFieldNameTracker.textColor = .ypGray
        textFieldNameTracker.backgroundColor = .ypLightGray
        textFieldNameTracker.layer.cornerRadius = 16
        textFieldNameTracker.leftViewMode = .always
        return textFieldNameTracker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(textFieldNameTracker)
        textFieldNameTracker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textFieldNameTracker.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            textFieldNameTracker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textFieldNameTracker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textFieldNameTracker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
