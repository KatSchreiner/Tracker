import Foundation

protocol ConfigureTypeTrackerDelegate: AnyObject {
    func selectTypeTracker(cell: CreateNewCategoryCell)
    func calculateTableHeight(width: CGFloat) -> CGSize
}
