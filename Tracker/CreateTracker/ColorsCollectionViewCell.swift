//
//  ColorsCollectionViewCell.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 02.07.2024.
//

import UIKit

final class ColorsCollectionViewCell: UICollectionViewCell {
    
    static let colorIdentifier = "colorCell"
    
    var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 8
        return colorView
    }()
    
    override var isSelected: Bool {
        didSet {
            self.layer.cornerRadius = 8
            self.layer.borderWidth = self.isSelected ? 3 : 0
            self.layer.borderColor = self.isSelected ? colorView.backgroundColor?.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(color: UIColor) {
        colorView.backgroundColor = color
    }
}
