//
//  CollectionViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 01.07.2024.
//

import UIKit

final class HeaderCollectionViewCell: UICollectionReusableView {
    
    static let headerIdentifier = "header"
    
    lazy var titleLabelCell: UILabel = {
        let titleLabelCell = UILabel()
        titleLabelCell.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return titleLabelCell
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabelCell)
        titleLabelCell.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            titleLabelCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            titleLabelCell.centerYAnchor.constraint(equalTo: centerYAnchor)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
