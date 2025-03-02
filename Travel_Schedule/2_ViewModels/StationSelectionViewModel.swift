//
//  StationSelectionViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation
import SwiftUI
import Combine

class StationSelectionViewModel: ObservableObject {
    @Published var stations: [String] = []
    @Published var filteredStations: [String] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedCity: String = ""
    @Published var selectedStation: String? = nil
    
    private let stationsService: StationsListServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var onStationSelected: ((String) -> Void)?
    
    init(city: String,
         stationsService: StationsListServiceProtocol = ServiceManager.shared.createStationsListService()) {
        self.stationsService = stationsService
        self.selectedCity = city
        self.stations = defaultStations // Предполагаем, что есть список станций по умолчанию
        self.filteredStations = self.stations
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.filterStations(with: text)
            }
            .store(in: &cancellables)
    }
    
    func selectStation(_ station: String) {
        selectedStation = station
        onStationSelected?(station)
    }
    
    private func filterStations(with query: String) {
        if query.isEmpty {
            filteredStations = stations
        } else {
            filteredStations = stations.filter { $0.lowercased().contains(query.lowercased()) }
        }
    }
    
    @MainActor
    func loadStationsForCity() async {
        isLoading = true
        errorMessage = nil
        
        // Здесь будет логика загрузки станций
        
        isLoading = false
        self.filterStations(with: searchText)
    }
}
