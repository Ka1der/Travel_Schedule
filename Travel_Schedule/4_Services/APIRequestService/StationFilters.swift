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
        let cities = response.countries?
            .first { $0.title == "Россия" }?
            .regions?
            .compactMap { $0.settlements }
            .flatMap { $0 }
            .compactMap { $0.title } ?? []
        
        let uniqueCities = Array(Set(cities)).sorted()
        CitiesStorage.shared.updateCities(uniqueCities)
        print("\nГорода России: \(uniqueCities.count)")
    }
    
    func filterRussianStations(from response: Components.Schemas.StationsList) {
        var stats = StationStatistics()
        
        if let russia = response.countries?.first(where: { $0.title == "Россия" }) {
            let allStations = russia.regions?
                .compactMap { $0.settlements }
                .flatMap { $0 }
                .compactMap { $0.stations }
                .flatMap { $0 } ?? []
            
            stats.total = allStations.count
            
            for station in allStations {
                if let title = station.title {
                    if !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        if station.codes?.yandex_code != nil {
                            stats.withCodes += 1
                        } else {
                            stats.withoutCodes += 1
                        }
                    } else {
                        stats.withEmptyNames += 1
                    }
                } else {
                    stats.withoutNames += 1
                }
            }
        }
        
        print("Статистика станций в России:")
        print("- Всего станций: \(stats.total)")
        print("- С кодами: \(stats.withCodes)")
        print("- Без кодов: \(stats.withoutCodes)")
        print("- С пустыми названиями: \(stats.withEmptyNames)")
        print("- Без названий: \(stats.withoutNames)")
    }
    
    private func createCityToStationsMap(from response: Components.Schemas.StationsList) {
        cityToStationsMap.removeAll()
        var skippedCount = 0
        
        guard let russia = response.countries?.first(where: { $0.title == "Россия" }) else {
            return
        }
        
        for region in russia.regions ?? [] {
            for settlement in region.settlements ?? [] {
                guard let cityName = settlement.title else { continue }
                var stationsForCity: [StationInfo] = []
                for station in settlement.stations ?? [] {
                    if let title = station.title,
                       !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                       let code = station.codes?.yandex_code {
                        
                        stationsForCity.append((
                            title: title,
                            code: code,
                            stationType: station.station_type ?? "Не указан",
                            transportType: station.transport_type ?? "Не указан"
                        ))
                    } else {
                        skippedCount += 1
                    }
                }
                if !stationsForCity.isEmpty {
                    cityToStationsMap[cityName] = stationsForCity
                }
            }
        }
        
        print("Пропущено станций без названия или кода: \(skippedCount)")
    }
}

// MARK: - Helper Structures

private struct StationStatistics {
    var total = 0
    var withCodes = 0
    var withoutCodes = 0
    var withEmptyNames = 0
    var withoutNames = 0
}
