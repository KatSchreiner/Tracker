//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 20.06.2024.
//

import Foundation
import UIKit

final class StatisticViewController: UIViewController {
    
    private lazy var titleStatistic: UILabel = {
        let titleStatistic = UILabel()
        return titleStatistic
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView() 
        setupTitleStatistic()
    }

    private func ifTrackerEmpty() {
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        [titleStatistic].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
    }
    
    private func setupTitleStatistic() {
        titleStatistic.text = "Статистика"
        titleStatistic.textColor = .ypBlackDay
        titleStatistic.font = UIFont.boldSystemFont(ofSize: 34.0)
        NSLayoutConstraint.activate([
            titleStatistic.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleStatistic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48)
        ])
    }
    
}
