import Foundation

enum WeekDay: String, CaseIterable, Codable {
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
    case sunday = "Вс"
}

extension WeekDay {
    var fullName: String {
        switch self {
        case .monday:
            return "weekday_monday".localized()
        case .tuesday:
            return "weekday_tuesday".localized()
        case .wednesday:
            return "weekday_wednesday".localized()
        case .thursday:
            return "weekday_thursday".localized()
        case .friday:
            return "weekday_friday".localized()
        case .saturday:
            return "weekday_saturday".localized()
        case .sunday:
            return "weekday_sunday".localized()
        }
    }
    
    var shortName: String {
        switch self {
        case .monday:
            return "mon".localized()
        case .tuesday:
            return "tue".localized()
        case .wednesday:
            return "wed".localized()
        case .thursday:
            return  "thu".localized()
        case .friday:
            return "fri".localized()
        case .saturday:
            return "sat".localized()
        case .sunday:
            return "sun".localized()
        }
    }
}
