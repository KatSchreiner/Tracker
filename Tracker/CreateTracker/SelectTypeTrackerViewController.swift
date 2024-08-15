//
//  SelectTypeTrackerViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 25.06.2024.
//

import UIKit

final class SelectTypeTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: CreateTrackerDelegate?
    
    // MARK: - Private Properties
    private lazy var addNewHabit: UIButton = {
        let addNewHabit = UIButton(type: .custom)
        addNewHabit.setTitle("habit".localized(), for: .normal)
        addNewHabit.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addNewHabit.setTitleColor(.whiteDay, for: .normal)
        addNewHabit.layer.cornerRadius = 16
        addNewHabit.backgroundColor = .ypBlackDay
        addNewHabit.addTarget(self, action: #selector(didTapCreateNewHabit), for: .touchUpInside)
        return addNewHabit
    }()
    
    private lazy var irregularEvent: UIButton = {
        let irregularEvent = UIButton(type: .custom)
        irregularEvent.setTitle("events".localized(), for: .normal)
        irregularEvent.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        irregularEvent.setTitleColor(.ypWhiteDay, for: .normal)
        irregularEvent.layer.cornerRadius = 16
        irregularEvent.backgroundColor = .ypWhiteNight
        irregularEvent.addTarget(self, action: #selector(didTapCreateNewIrregularEvent), for: .touchUpInside)
        return irregularEvent
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addNewHabit, irregularEvent])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - IBAction
    @objc private func didTapCreateNewHabit() {
        let createNewHabit = CreateNewHabitViewController()
        createNewHabit.createTrackerDelegate = delegate
        navigationController?.pushViewController(createNewHabit, animated: true)
    }
    
    @objc private func didTapCreateNewIrregularEvent() {
        let createNewSchedule = CreateNewEventViewController()
        createNewSchedule.createTrackerDelegate = delegate
        navigationController?.pushViewController(createNewSchedule, animated: true)
    }
    
    // MARK: - private Methods
    private func setupView() {
        view.backgroundColor = .ypBlackNight
        
        navigationItem.title = "create_tracker".localized()
        
        [stackView, addNewHabit, irregularEvent].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(stackView)
        
        constraintStackView()
        constraintAddNewHabitButton()
        constraintIrregularEventButton()
    }
    
    private func constraintAddNewHabitButton() {
        NSLayoutConstraint.activate([
            addNewHabit.heightAnchor.constraint(equalToConstant: 60),
            addNewHabit.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            addNewHabit.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
    private func constraintIrregularEventButton() {
        NSLayoutConstraint.activate([
            irregularEvent.heightAnchor.constraint(equalToConstant: 60),
            irregularEvent.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            irregularEvent.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
    private func constraintStackView() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
