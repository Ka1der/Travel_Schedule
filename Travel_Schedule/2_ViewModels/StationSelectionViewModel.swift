//
//  StationSelectionViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation
import SwiftUI
import Combine

class StationsStorage {
    static let shared = StationsStorage()
    
    private(set) var stations: [String] = []
    private(set) var cityStations: [String] = []
    
    let stationsPublisher = PassthroughSubject<[String], Never>()
    let cityStationsPublisher = PassthroughSubject<[String], Never>()
    
    private init() {}
    
    func updateStations(_ newStations: [String]) {
        stations = newStations
        stationsPublisher.send(newStations)
    }
    
    func updateStationsForCity(_ newStations: [String]) {
        cityStations = newStations
        cityStationsPublisher.send(newStations)
    }
}

class StationSelectionViewModel: ObservableObject {
    @Published var stations: [String] = []
    @Published var filteredStations: [String] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedCity: String = ""
    @Published var selectedStation: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    var onStationSelected: ((String) -> Void)?
    
    init(city: String) {
        
        self.selectedCity = city

        StationFilters.shared.setSelectedCity(city)
        
        StationFilters.shared.selectedCityStationsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] cityStations in
                guard let self = self else { return }
                self.stations = cityStations
                self.filterStations(with: self.searchText)
                print("Получены станции для города \"\(self.selectedCity)\": \(cityStations.count)")
            }
            .store(in: &cancellables)
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.filterStations(with: text)
            }
            .store(in: &cancellables)
        
        self.stations = StationsStorage.shared.cityStations
        self.filteredStations = self.stations
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
}
