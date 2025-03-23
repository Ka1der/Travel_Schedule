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
    
    private(set) var stations: [(title: String, code: String)] = []
    private(set) var cityStations: [(title: String, code: String)] = []
    
    let stationsPublisher = PassthroughSubject<[(title: String, code: String)], Never>()
    let cityStationsPublisher = PassthroughSubject<[(title: String, code: String)], Never>()
    
    private init() {}
    
    func updateStations(_ newStations: [(title: String, code: String)]) {
        stations = newStations
        stationsPublisher.send(newStations)
    }
    
    func updateStationsForCity(_ newStations: [(title: String, code: String)]) {
        cityStations = newStations
        cityStationsPublisher.send(newStations)
    }
}

class StationSelectionViewModel: ObservableObject {
    @Published var stations: [(title: String, code: String)] = []
    @Published var filteredStations: [(title: String, code: String)] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedCity: String = ""
    @Published var selectedStation: (title: String, code: String)? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    var onStationSelected: (((title: String, code: String)) -> Void)?
    
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
    
    func selectStation(_ station: (title: String, code: String)) {
        selectedStation = station
        print("StationSelectionViewModel: выбрана станция \"\(station.title)\" с кодом \"\(station.code)\"")
        onStationSelected?(station)
    }
    
    private func filterStations(with query: String) {
        if query.isEmpty {
            filteredStations = stations
        } else {
            filteredStations = stations.filter { $0.title.lowercased().contains(query.lowercased()) }
        }
    }
}
