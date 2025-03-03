//
//  StationSelectionViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation
import SwiftUI
import Combine

private var defaultStations = [
    "Ленинградский вокзал",
    "Казанский вокзал",
    "Ярославский вокзал",
    "Курский вокзал",
    "Киевский вокзал"
]

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
        self.stations = defaultStations
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
}
