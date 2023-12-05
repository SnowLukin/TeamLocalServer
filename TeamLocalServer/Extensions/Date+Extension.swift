//
//  Date+Extension.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 04.12.2023.
//

import Foundation

extension Date {
    func teamMemberFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, yyyy"
        return formatter.string(from: self)
    }
    
    func daysFromToday() -> Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: .now)
        let startOfGivenDate = calendar.startOfDay(for: self)
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfGivenDate)
        return components.day ?? 0
    }
}
