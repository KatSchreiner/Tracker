import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func sendSelectedDays(selectedDays: [WeekDay])
}
