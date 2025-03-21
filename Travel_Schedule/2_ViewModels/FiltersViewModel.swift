//
//  FiltersViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 21.03.2025.
//

import SwiftUI
import Combine

final class FiltersViewModel: ObservableObject {
    @Published var selectedTimes: Set<String> = []
    @Published var showTransfers: Bool? = nil
    
    let timePeriods = [
        "Утро 06:00 - 12:00",
        "День 12:00 - 18:00",
        "Вечер 18:00 - 00:00",
        "Ночь 00:00 - 06:00"
    ]
    
    var canApplyFilters: Bool {
        return !selectedTimes.isEmpty && showTransfers != nil
    }
    
    func toggleTimeSelection(for period: String) {
        if selectedTimes.contains(period) {
            selectedTimes.remove(period)
        } else {
            selectedTimes.insert(period)
        }
    }
    
    func setShowTransfers(value: Bool) {
        showTransfers = value
    }
    
    func applyFilters() {
        // Логика применения фильтров
    }
}
