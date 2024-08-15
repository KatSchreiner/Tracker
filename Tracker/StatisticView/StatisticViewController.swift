//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 20.06.2024.
//

import Foundation
import UIKit

final class StatisticViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
    }

    private func setupNavigation() {
        title = "statistics".localized()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func setupView() {
        view.backgroundColor = .white
    }
}
