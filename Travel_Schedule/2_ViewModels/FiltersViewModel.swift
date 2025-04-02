//
//  FiltersViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 21.03.2025.
//

import SwiftUI
import Combine

class FiltersViewModel: ObservableObject {
    @Published var selectedTimes: Set<String> = []
    @Published var showTransfers: Bool = true
    
    let timePeriods = FilterSettings.timePeriods
    private let filterService = FilterService.shared
    
    init() {
        self.selectedTimes = filterService.currentFilters.selectedTimePeriodsIndices
        self.showTransfers = filterService.currentFilters.showTransfers
    }
    
    var canApplyFilters: Bool {
        return true
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
        let newFilters = FilterSettings(
            selectedTimePeriodsIndices: selectedTimes,
            showTransfers: showTransfers
        )
        
        filterService.updateFilters(newFilters)
    }
}
