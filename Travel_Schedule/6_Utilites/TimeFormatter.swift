//
//  TimeFormatter.swift
//  Travel_Schedule
//
//  Created by Kaider on 27.03.2025.
//

import Foundation

struct TimeFormatter {
    static func formatDuration(minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        if mins > 0 {
            return "\(hours)ч \(mins)м"
        } else {
            return "\(hours)ч"
        }
    }
    
    static func formatTimeFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    static func formatDateToRussian(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
}
