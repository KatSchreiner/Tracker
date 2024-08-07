//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 02.08.2024.
//

import UIKit

final class SinglePageViewController: UIViewController {
    
    lazy var backgroundImage: UIImageView = {
        let background = UIImageView()
        return background
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        title.textColor = .ypWhiteNight
        title.numberOfLines = 2
        title.textAlignment = .center
        return title
    }()
    
    init(background: UIImage, title: String) {
        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = title
        backgroundImage.image = background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        [backgroundImage, titleLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270)
        ])
    }
}
