//
//  WeekDayTransformer.swift
//  Tracker
//
//  Created by Екатерина Шрайнер on 28.07.2024.
//

import Foundation

@objc
final class WeekDayTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        if let data = value as? NSData {
            return data
        }
        guard let days = value as? [WeekDay] else {
            return nil
        }
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        if let data = value as? [WeekDay] {
            return data
        }
        guard let data = value as? NSData else {
            return nil
        }
        return try? JSONDecoder().decode([WeekDay].self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(WeekDayTransformer(), forName: NSValueTransformerName(rawValue: String(describing: WeekDayTransformer.self)))
    }
}
