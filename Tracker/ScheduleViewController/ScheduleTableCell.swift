//
//  ScheduleTableCell.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 28.06.2024.
//

import UIKit

class ScheduleTableCell: UITableViewCell {
    static let cell = "ScheduleTableCell"
    
    lazy var daySwitch: UISwitch = {
        let daySwitch = UISwitch()
        daySwitch.setOn(false, animated: true)
        daySwitch.onTintColor = .yBlue
        return daySwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    private func setupView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(daySwitch)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        daySwitch.frame = CGRect(x: contentView.bounds.width - 65, y: 20, width: 51, height: 31)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
