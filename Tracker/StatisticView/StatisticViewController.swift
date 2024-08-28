import UIKit

final class StatisticViewController: UIViewController {
    
    // MARK: - Private Properties
    private lazy var placeholderImage: UIImageView = {
        let placeholderImage = UIImageView()
        placeholderImage.image = UIImage(named: "no_statistics")
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        return placeholderImage
    }()
    
    private lazy var placeHolderLabel: UILabel = {
        var placeHolderLabel = UILabel()
        placeHolderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeHolderLabel.text = "nothing_analyze".localized()
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        return placeHolderLabel
    }()
    
    private lazy var placeholderStackView: UIStackView = {
        let placeholderStackView = UIStackView(arrangedSubviews: [placeholderImage, placeHolderLabel])
        placeholderStackView.axis = .vertical
        placeholderStackView.alignment = .center
        placeholderStackView.spacing = 8
        return placeholderStackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: "statisticsCell")
        return tableView
    }()
    
    private var statisticsData: [StatisticsData] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupNavigation() {
        title = "statistics".localized()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupView() {
        view.backgroundColor = .yWhite
        
        [placeholderStackView, tableView].forEach { [weak self] view in
            guard let self = self else { return }
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        updatePlaceholderVisibility()
        
        NSLayoutConstraint.activate([
            placeholderStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            tableView.heightAnchor.constraint(equalToConstant: view.frame.height - 400)
        ])
    }
    
    private func updatePlaceholderVisibility() {
        placeholderStackView.isHidden = !statisticsData.isEmpty
        tableView.isHidden = statisticsData.isEmpty
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statisticsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "statisticsCell", for: indexPath) as? StatisticTableViewCell else { return UITableViewCell() }
        
        let data = statisticsData[indexPath.row]
        
        cell.customTextLabel.text = String(data.countStatistics)
        cell.customTextLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        cell.customDetailTextLabel.text = data.subTitle
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
