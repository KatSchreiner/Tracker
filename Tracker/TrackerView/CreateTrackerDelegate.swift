import Foundation

protocol CreateTrackerDelegate: AnyObject {
    func createTracker(tracker: Tracker, category: String)
    func updateTracker(tracker: Tracker, category: String)
}
