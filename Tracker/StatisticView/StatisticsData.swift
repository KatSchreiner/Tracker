import Foundation

enum StatisticsData: Int, CaseIterable {
    case bestPeriod
    case perfectDay
    case trackersCompleted
    case averageValue
    
    var countStatistics: Int {
        switch self {
        case .bestPeriod:
            return 6
        case .perfectDay:
            return 2
        case .trackersCompleted:
            return 5
        case .averageValue:
            return 4
        }
    }
    
    var subTitle: String {
        switch self {
        case .bestPeriod:
            return "Лучший период"
        case .perfectDay:
            return "Идеальные дни"
        case .trackersCompleted:
            return "Трекеров завершено"
        case .averageValue:
            return "Среднее значение"
        }
    }
}
