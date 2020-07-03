//
//  DayFormat.swift
//  DrinkTrackerSample
//
//  Created by Mikhail Apurin on 2020/07/03.
//

import Foundation

enum DayFormat {
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.doesRelativeDateFormatting = true
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    
    static let timeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.doesRelativeDateFormatting = true
        df.dateStyle = .none
        df.timeStyle = .short
        return df
    }()
    
}
