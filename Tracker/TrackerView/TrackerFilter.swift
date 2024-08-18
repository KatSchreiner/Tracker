import Foundation

enum TrackerFilter: Int, CaseIterable {
    case allTrackers
    case trackersToday
    case completed
    case uncompleted
    
    var title: String {
        switch self {
        
        case .allTrackers:
            return "Все трекеры"
        case .trackersToday:
            return "Трекеры на сегодня"
        case .completed:
            return "Завершенные"
        case .uncompleted:
            return "Не завершенные"
        }
    }
}
