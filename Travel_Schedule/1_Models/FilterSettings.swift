//
//  FilterSettings.swift
//  Travel_Schedule
//
//  Created by Kaider on 01.04.2025.
//

import Foundation

struct FilterSettings: Equatable, Sendable {
    var selectedTimePeriodsIndices: Set<String> = []
    var showTransfers: Bool = true
    
    static let timePeriods = ["Утро (06:00 - 12:00)",
                              "День (12:00 - 18:00)",
                              "Вечер (18:00 - 00:00)",
                              "Ночь (00:00 - 06:00)"]
    
    func isTimeInSelectedPeriods(_ timeString: String?) -> Bool {
        if selectedTimePeriodsIndices.isEmpty {
            return true
        }
        
        guard let timeStr = timeString else { return false }
        
        let components = timeStr.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              hour >= 0 && hour < 24 else {
            return false
        }
        
        for period in selectedTimePeriodsIndices {
            if period == "Утро (06:00 - 12:00)" && (hour >= 6 && hour < 12) { return true }
            if period == "День (12:00 - 18:00)" && (hour >= 12 && hour < 18) { return true }
            if period == "Вечер (18:00 - 00:00)" && (hour >= 18 && hour < 24) { return true }
            if period == "Ночь (00:00 - 06:00)" && (hour >= 0 && hour < 6) { return true }
        }
        return false
    }
}

class FilterService: ObservableObject {
    static let shared = FilterService()
    
    @Published var currentFilters = FilterSettings()
    
    private init() { }
    
    func updateFilters(_ filters: FilterSettings) {
        currentFilters = filters
    }
}
