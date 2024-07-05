//
//  CreateHabitViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 27.06.2024.
//

import UIKit

final class CreateNewHabitViewController: CreateNewTrackerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Новая привычка"
        view.backgroundColor = .white
        //        navigationItem.hidesBackButton = true
    }
}
