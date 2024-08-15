import Foundation

protocol CreateTrackerDelegate: AnyObject {
    func createTracker(tracker: Tracker, category: String)
}
