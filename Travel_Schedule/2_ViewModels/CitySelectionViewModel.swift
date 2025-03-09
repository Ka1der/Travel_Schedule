//
//  CitySelectionViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation
import SwiftUI
import Combine

private var mockCities = [
    "Москва",
      "Санкт-Петербург",
      "Краснодар",
      "Екатеринбург",
      "Новосибирск"
]

private var defaultCities = [
    "Москва",
      "Санкт-Петербург",
      "Краснодар",
      "Екатеринбург",
      "Новосибирск"
]

class CitySelectionViewModel: ObservableObject {
    @Published var cities: [String] = defaultCities
    @Published var filteredCities: [String] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.filteredCities = cities
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else { return }
                self.filterCities(with: text)
            }
            .store(in: &cancellables)
    }
    
    private func filterCities(with query: String) {
        if query.isEmpty {
            filteredCities = cities
        } else {
            filteredCities = cities.filter { $0.lowercased().contains(query.lowercased()) }
        }
    }
}
