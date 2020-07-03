//
//  Model.swift
//  DrinkTrackerSample
//
//  Created by Mikhail Apurin on 2020/07/03.
//

import Foundation

enum Strings {
    static func glassCount(_ amount: Int) -> String {
        if amount == 1 {
            return "1 glass"
        } else {
            return "\(amount) glasses"
        }
    }
}
