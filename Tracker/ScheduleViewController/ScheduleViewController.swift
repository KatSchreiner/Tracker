import UIKit

class ScheduleViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var scheduleDelegate: ScheduleViewControllerDelegate?
    
    var selectedDays = [WeekDay]()
    
    // MARK: - Private Properties
    private var weekDays: [WeekDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.separatorColor = .yGray
        tableView.frame = .zero
        tableView.register(ScheduleTableCell.self, forCellReuseIdentifier: ScheduleTableCell.cell)
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .custom)
        doneButton.setTitle("done".localized(), for: .normal)
        doneButton.setTitleColor(.yWhite, for: .normal)
        doneButton.backgroundColor = .yBlack
        doneButton.layer.cornerRadius = 16
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return doneButton
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - IBAction
    @objc private func didTapDoneButton() {
        navigationController?.popViewController(animated: true)
        scheduleDelegate?.sendSelectedDays(selectedDays: selectedDays)
    }
    
    @objc func switchDidChange(_ sender: UISwitch) {
        let weekDay = weekDays[sender.tag]
        if sender.isOn {
            selectedDays.append(weekDay)
        } else {
            selectedDays.removeAll { $0 == weekDay }
        }
    }
    
    // MARK: Private Methods
    private func setupView() {
        [tableView, doneButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        view.backgroundColor = .yWhite
        navigationItem.hidesBackButton = true
        self.title = "schedule".localized()
        
        addConstraint()
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureCell(cell: ScheduleTableCell, indexPath: IndexPath) {
        cell.backgroundColor = .yBackground
        let weekDay = weekDays[indexPath.row]
        cell.textLabel?.text = weekDay.fullName
        cell.daySwitch.addTarget(self, action: #selector(switchDidChange(_:)), for: .valueChanged)
        cell.daySwitch.tag = indexPath.row
        
        cell.daySwitch.setOn(selectedDays.contains(weekDay), animated: true)
        
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableCell.cell, for: indexPath) as! ScheduleTableCell
        
        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == numberOfRows - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else if indexPath.row == numberOfRows - 7 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else if indexPath.row == numberOfRows - 6 {
            cell.separatorInset = UIEdgeInsets(top: 1, left: 16, bottom: 0, right: 16)
        }
    }
}
