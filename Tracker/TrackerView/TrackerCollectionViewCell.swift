//
//  CollectionViewCell.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 24.06.2024.
//

import UIKit

protocol TrackerCompletionDelegate: AnyObject {
    func didUpdateTrackerCompletion(trackerId: UUID, indexPath: IndexPath, isTrackerCompleted: Bool)
}

class TrackerCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "TrackerCell"
    weak var delegate: TrackerCompletionDelegate?
    
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    var isTrackerCompleted: Bool = false
    
    var daysCount: Int = 0 {
        didSet {
            updateDaysCountLabel()
        }
    }
    
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
        addButtonCell.layer.cornerRadius = 17
        addButtonCell.tintColor = .ypWhiteDay
        addButtonCell.addTarget(self, action: #selector(didTapCompletedTrackers), for: .touchUpInside)
        return addButtonCell
    }()
    
    lazy var bodyView: UIView = {
        let bodyView = UIView()
        bodyView.layer.cornerRadius = 16
        return bodyView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAddButton(tracker: Tracker, indexPath: IndexPath, completedForCurrentDate: Int, isTrackerCompleted: Bool) {
        self.isTrackerCompleted = isTrackerCompleted
        self.trackerId = tracker.id
        self.indexPath = indexPath
                
        titleLabelCell.text = tracker.name
        emojiLabelCell.text = tracker.emoji
        bodyView.backgroundColor = tracker.color
        addButtonCell.backgroundColor = tracker.color
        daysCount = completedForCurrentDate
        
        let image = isTrackerCompleted ? "checkmark" : "plus"
        addButtonCell.setImage(UIImage(systemName: image), for: .normal)
        addButtonCell.backgroundColor = isTrackerCompleted ? bodyView.backgroundColor?.withAlphaComponent(0.3) : bodyView.backgroundColor
    }
    
    func updateDaysCountLabel() {
        var days: String
        switch daysCount % 10 {
        case 1:
            days = "день"
        case 2, 3, 4:
            days = "дня"
        default:
            days = "дней"
        }
        daysCountLabelCell.text = String(daysCount) + " " + days
    }
    
    @objc func didTapCompletedTrackers() {
        guard let trackerId, let indexPath = indexPath else { return }
        if isTrackerCompleted {
            delegate?.didUpdateTrackerCompletion(trackerId: trackerId, indexPath: indexPath, isTrackerCompleted: false)
        } else {
            delegate?.didUpdateTrackerCompletion(trackerId: trackerId, indexPath: indexPath, isTrackerCompleted: true)
        }
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
