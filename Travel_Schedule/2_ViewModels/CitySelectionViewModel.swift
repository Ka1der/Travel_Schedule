//
//  CitySelectionViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation
import SwiftUI
import Combine

private var defaultCities = [
    "Москва",
    "Санкт-Петербург",
    "Краснодар"
]

class CitySelectionViewModel: ObservableObject {
    @Published var cities: [String] = defaultCities
    @Published var filteredCities: [String] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let nearestSettlementService: NearestSettlementServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(nearestSettlementService: NearestSettlementServiceProtocol = ServiceManager.shared.createNearestSettlementService()) {
        self.nearestSettlementService = nearestSettlementService
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
    
    @MainActor
    func loadNearestCity(latitude: Double, longitude: Double, distance: Int = 50) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let settlement = try await nearestSettlementService.getNearestSettlement(
                lat: latitude,
                lng: longitude,
                distance: distance
            )
            
            if let cityName = settlement.settlement?.name, !cityName.isEmpty {
                if !self.cities.contains(cityName) {
                    self.cities.append(cityName)
                    self.cities.sort()
                    self.filterCities(with: searchText)
                }
            }
        } catch {
            errorMessage = "Ошибка при загрузке городов: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
