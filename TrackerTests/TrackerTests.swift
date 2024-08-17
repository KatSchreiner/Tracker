import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testTrackerViewControllerLight() {
        let view = TrackersViewController()
        assertSnapshot(of: view, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackerViewControllerLight() {
        let view = TrackersViewController()
        assertSnapshot(of: view, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
