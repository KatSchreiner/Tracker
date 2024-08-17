import UIKit

class CreateNewHabitViewController: CreateNewTrackerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "new_habit".localized()
        view.backgroundColor = .yWhite
        navigationItem.hidesBackButton = true
        
        self.delegate = self
    }
}

extension CreateNewHabitViewController: ConfigureTypeTrackerDelegate {
    
    func selectTypeTracker(cell: CreateNewCategoryCell) {
        print("SelectTypeTrackerDelegate Habit called!")
        cell.typeTracker = .habit
    }
    
    func calculateTableHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 150)
    }
}
