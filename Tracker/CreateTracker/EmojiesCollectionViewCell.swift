//
//  EmojiesCollectionViewCell.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 02.07.2024.
//

import UIKit

final class EmojiesCollectionViewCell: UICollectionViewCell {
    
    static let emojiIdentifier = "emojiCell"

    var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return emojiLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(emoji: String) {
        emojiLabel.text = emoji
    }
}
