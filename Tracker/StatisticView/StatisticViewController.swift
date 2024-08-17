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
        view.backgroundColor = .yWhite
    }
}
