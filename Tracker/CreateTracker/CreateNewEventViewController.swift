//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 25.06.2024.
//

import UIKit

final class CreateNewEventViewController: CreateNewTrackerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Новое нерегулярное событие"
        view.backgroundColor = .white
        //        navigationItem.hidesBackButton = true
    }
}
