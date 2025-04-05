//
//  StationFilters.swift
//  Travel_Schedule
//
//  Created by Kaider on 22.03.2025.
//

import Foundation
import Combine

typealias StationInfo = (title: String, code: String, stationType: String, transportType: String)

final class StationFilters {
    private var cancellables = Set<AnyCancellable>()
    private var cityToStationsMap: [String: [StationInfo]] = [:]
    @MainActor static let shared = StationFilters()
    
    let selectedCityStationsPublisher = PassthroughSubject<[StationInfo], Never>()
    private var selectedCity: String? = nil
    
    private init() {}
    
    // MARK: - Public Methods
    
    func setSelectedCity(_ city: String) {
        guard selectedCity != city else { return }
        
        selectedCity = city
        let stations = getStationsForCity(city: city)
        selectedCityStationsPublisher.send(stations)
        StationsStorage.shared.updateStationsForCity(stations)
        print("Выбран город: \"\(city)\", число станций: \(stations.count)")
    }
    
    func getSelectedCity() -> String? {
        return selectedCity
    }
    
    func getStationsForCity(city: String) -> [StationInfo] {
        return cityToStationsMap[city] ?? []
    }
    
    func processApiResponse(_ response: Components.Schemas.StationsList) {
        filterRussianCities(from: response)
        filterRussianStations(from: response)
        createCityToStationsMap(from: response)
    }
    
    // MARK: - Filtering Methods
    
    func filterRussianCities(from response: Components.Schemas.StationsList) {
        var cities: [String] = []
        var uniqueCities: [String] = []
        
        if let russia = response.countries?.first(where: { $0.title == "Россия" }) {
            if let regions = russia.regions {
                for region in regions {
                    if let settlements = region.settlements {
                        for settlement in settlements {
                            if let title = settlement.title,
                               !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                cities.append(title)
                            }
                        }
                    }
                }
            }
        }
        
        cities.sort()
        for city in cities {
            if uniqueCities.isEmpty || uniqueCities.last! != city {
                uniqueCities.append(city)
            }
        }
        
        CitiesStorage.shared.updateCities(uniqueCities)
        print("\nГорода России: \(uniqueCities.count)")
    }
    
    func filterRussianStations(from response: Components.Schemas.StationsList) {
        var stationsWithCodes = 0
        
        if let russia = response.countries?.first(where: { $0.title == "Россия" }) {
            let allStations = russia.regions?
                .compactMap { $0.settlements }
                .flatMap { $0 }
                .compactMap { $0.stations }
                .flatMap { $0 } ?? []
            
            for station in allStations {
                if let title = station.title,
                   !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                   station.codes?.yandex_code != nil {
                    stationsWithCodes += 1
                }
            }
        }
        print("Станций с кодами: \(stationsWithCodes)")
    }
    
    private func createCityToStationsMap(from response: Components.Schemas.StationsList) {
        cityToStationsMap.removeAll()
        
        guard let russia = response.countries?.first(where: { $0.title == "Россия" }) else {
            return
        }
        
        for region in russia.regions ?? [] {
            for settlement in region.settlements ?? [] {
                guard let cityName = settlement.title,
                      !cityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    continue
                }
                
                var stationsForCity: [StationInfo] = []
                
                for station in settlement.stations ?? [] {
                    guard let title = station.title,
                          !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                          let code = station.codes?.yandex_code else {
                        continue
                    }
                    
                    stationsForCity.append((
                        title: title,
                        code: code,
                        stationType: station.station_type ?? "Не указан",
                        transportType: station.transport_type ?? "Не указан"
                    ))
                }
                
                if !stationsForCity.isEmpty {
                    cityToStationsMap[cityName] = stationsForCity
                }
            }
        }
    }
}
