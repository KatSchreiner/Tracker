import Foundation

enum TrackerFilter: Int, CaseIterable {
    case allTrackers
    case trackersToday
    case completed
    case uncompleted
    
    var title: String {
        switch self {
        
        case .allTrackers:
            return "all".localized()
        case .trackersToday:
            return "for_today".localized()
        case .completed:
            return "completed".localized()
        case .uncompleted:
            return "not_completed".localized()
        }
    }
}
