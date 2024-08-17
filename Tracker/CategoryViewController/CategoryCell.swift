//
//  CategoryCell.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 08.08.2024.
//

import UIKit

final class CategoryCell: UITableViewCell {
    static let identifier = "CategoryCell"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        backgroundColor = .yBackground
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
