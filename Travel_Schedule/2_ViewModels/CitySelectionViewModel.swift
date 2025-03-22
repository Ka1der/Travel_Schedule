//
//  CitySelectionViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation
import SwiftUI
import Combine

class CitiesStorage {
    static let shared = CitiesStorage()
    
    private(set) var cities: [String] = [
        "Москва",
        "Санкт-Петербург",
        "Краснодар",
        "Екатеринбург",
        "Новосибирск"
    ]
    
    let citiesPublisher = PassthroughSubject<[String], Never>()
    
    private init() {}
    
    func updateCities(_ newCities: [String]) {
        cities = newCities
        citiesPublisher.send(newCities)
    }
}

class CitySelectionViewModel: ObservableObject {
    @Published var cities: [String] = []
    @Published var filteredCities: [String] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.cities = CitiesStorage.shared.cities
        self.filteredCities = cities
        
        CitiesStorage.shared.citiesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newCities in
                guard let self = self else { return }
                self.cities = newCities
                self.filterCities(with: self.searchText)
            }
            .store(in: &cancellables)
        
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
