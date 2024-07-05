//
//  CollectionViewCell.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 24.06.2024.
//

import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    
    static var trackerCell = "TrackerCell"
    
    lazy var titleLabelCell: UILabel = {
        let titleLabelCell = UILabel()
        titleLabelCell.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabelCell.textColor = .ypWhiteDay
        return titleLabelCell
    }()
    
    lazy var emojiLabelCell: UILabel = {
        let emojiLabelCell = UILabel()
        emojiLabelCell.font = UIFont.systemFont(ofSize: 12)
        return emojiLabelCell
    }()
    
    lazy var emojiCircle: UIView = {
        let emojiCircle = UIView()
        emojiCircle.layer.cornerRadius = 12
        emojiCircle.backgroundColor = .ypBackgroundDay
        return emojiCircle
    }()
    
    lazy var daysCountLabelCell: UILabel = {
        let daysCountLabelCell = UILabel()
        daysCountLabelCell.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return daysCountLabelCell
    }()
    
    lazy var addButtonCell: UIButton = {
        let addButtonCell = UIButton()
        let image = UIImage(named: "plus")
        addButtonCell.setImage(UIImage(systemName: "plus"), for: .normal)
        addButtonCell.backgroundColor = .green
        addButtonCell.layer.cornerRadius = 17
        addButtonCell.tintColor = .ypWhiteDay
        addButtonCell.addTarget(self, action: #selector(didChangeAddButtonCell), for: .touchUpInside)
        return addButtonCell
    }()
    
    lazy var bodyView: UIView = {
        let bodyView = UIView()
        bodyView.layer.cornerRadius = 16
        bodyView.backgroundColor = .ypRed
        return bodyView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    @objc private func didChangeAddButtonCell() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        bodyView.addSubview(titleLabelCell)
        titleLabelCell.translatesAutoresizingMaskIntoConstraints = false
        
        emojiCircle.addSubview(emojiLabelCell)
        emojiLabelCell.translatesAutoresizingMaskIntoConstraints = false
        
        bodyView.addSubview(emojiCircle)
        emojiCircle.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(daysCountLabelCell)
        daysCountLabelCell.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(addButtonCell)
        addButtonCell.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintView()
    }
    
    private func addConstraintView() {
        NSLayoutConstraint.activate([
            emojiLabelCell.topAnchor.constraint(equalTo: emojiCircle.topAnchor, constant: 4),
            emojiLabelCell.leadingAnchor.constraint(equalTo: emojiCircle.leadingAnchor, constant: 4),
            emojiLabelCell.heightAnchor.constraint(equalToConstant: 24),
            emojiLabelCell.widthAnchor.constraint(equalToConstant: 24),
            emojiLabelCell.centerXAnchor.constraint(equalTo: emojiCircle.centerXAnchor),
            emojiLabelCell.centerYAnchor.constraint(equalTo: emojiCircle.centerYAnchor),
            emojiCircle.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 12),
            emojiCircle.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 12),
            emojiCircle.widthAnchor.constraint(equalToConstant: 24),
            emojiCircle.heightAnchor.constraint(equalToConstant: 24),
            titleLabelCell.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -12),
            titleLabelCell.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 12),
            titleLabelCell.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -12),
            daysCountLabelCell.centerYAnchor.constraint(equalTo: addButtonCell.centerYAnchor),
            daysCountLabelCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysCountLabelCell.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 16),
            addButtonCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            addButtonCell.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 8),
            addButtonCell.heightAnchor.constraint(equalToConstant: 34),
            addButtonCell.widthAnchor.constraint(equalToConstant: 34),
            bodyView.heightAnchor.constraint(equalToConstant: 90),
            bodyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
