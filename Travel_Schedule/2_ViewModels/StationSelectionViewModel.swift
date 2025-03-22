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
    
    private(set) var stations: [String] = [
        "Ленинградский вокзал",
        "Казанский вокзал",
        "Ярославский вокзал",
        "Курский вокзал",
        "Киевский вокзал"
    ]
    
    let stationsPublisher = PassthroughSubject<[String], Never>()
    
    private init() {}
    
    func updateStations(_ newStations: [String]) {
        stations = newStations
        stationsPublisher.send(newStations)
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
        self.stations = StationsStorage.shared.stations
        self.filteredStations = self.stations
        
        StationsStorage.shared.stationsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newStations in
                guard let self = self else { return }
                self.stations = newStations
                self.filterStations(with: self.searchText)
            }
            .store(in: &cancellables)
        
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
}
