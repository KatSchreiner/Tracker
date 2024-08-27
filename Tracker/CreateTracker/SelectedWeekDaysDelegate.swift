import Foundation

protocol SelectedWeekDaysDelegate: AnyObject {
    func sendSelectedWeekDays(_ selectedDays: [WeekDay])
}
