//
//  Date+days.swift
//  DrinkTrackerSample
//
//  Created by Mikhail Apurin on 2020/07/03.
//

import Foundation

extension Date {
    static func day(offsetFromToday: Int, calendar: Calendar = .current) -> Date {
        let date = calendar.date(byAdding: .day, value: -offsetFromToday, to: Date())!
        return calendar.startOfDay(for: date)
    }
    
    func days(enumeratingDownTo endDate: Date, calendar: Calendar = .current) -> [Date] {
        let endDate = calendar.startOfDay(for: endDate)
        var date = self
        var array: [Date] = []
        while date >= endDate {
            array.append(date)
            date = calendar.date(byAdding: .day, value: -1, to: date)!
        }
        return array
    }
    
    func dayRange(calendar: Calendar = .current) -> Range<Date> {
        let dayStart = calendar.startOfDay(for: self)
        let nextDayStart = calendar.date(byAdding: .day, value: 1, to: dayStart)!
        return (dayStart..<nextDayStart)
    }
    
    func sameDateWithCurrentTime() -> Date! {
        let comps = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        return Calendar.current.date(bySettingHour: comps.hour!, minute: comps.minute!, second: comps.second!, of: self)
    }
}
