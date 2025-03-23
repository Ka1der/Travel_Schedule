//
//  StationFilters.swift
//  Travel_Schedule
//
//  Created by Kaider on 22.03.2025.
//

import Foundation
import Combine

final class StationFilters {
    private var cancellables = Set<AnyCancellable>()
    private var cityToStationsMap: [String: [(
        title: String,
        code: String,
        stationType: String,
        transportType: String
    )]] = [:]
    static let shared = StationFilters()
    
    let selectedCityStationsPublisher = PassthroughSubject<[(
        title: String,
        code: String,
        stationType: String,
        transportType: String
    )], Never>()
    private var selectedCity: String? = nil
    
    private init() {}
    
    // Фильтрация городов России
    func filterRussianCities(from response: Components.Schemas.StationsList) {
        var cities = [String]()
        
        if let countries = response.countries {
            for country in countries {
                if country.title == "Россия" {
                    if let regions = country.regions {
                        for region in regions {
                            if let settlements = region.settlements {
                                for settlement in settlements {
                                    if let title = settlement.title {
                                        cities.append(title)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        let uniqueCities = Array(Set(cities)).sorted()
        CitiesStorage.shared.updateCities(uniqueCities)
        print("\nГорода России: \(uniqueCities.count)")
    }
    
    // Фильтрация станций России с корректным получением кода
    func filterRussianStations(from response: Components.Schemas.StationsList) {
        var stations: [(title: String, code: String, stationType: String, transportType: String)] = []
        var stationsCount = 0
        var stationsWithoutCodes = 0
        
        if let countries = response.countries {
            for country in countries {
                if country.title == "Россия" {
                    if let regions = country.regions {
                        for region in regions {
                            if let settlements = region.settlements {
                                for settlement in settlements {
                                    if let stationsList = settlement.stations {
                                        for station in stationsList {
                                            stationsCount += 1
                                            
                                            if let title = station.title {
                                                if let code = station.codes?.yandex_code {
                                                    stations.append((
                                                        title: title,
                                                        code: code,
                                                        stationType: station.station_type ?? "Не указан",
                                                        transportType: station.transport_type ?? "Не указан"
                                                    ))
                                                } else {
                                                    stationsWithoutCodes += 1
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        print("Всего станций в России: \(stationsCount)")
    }
    
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
    
    func getStationsForCity(city: String) -> [(title: String, code: String, stationType: String, transportType: String)] {
        return cityToStationsMap[city] ?? []
    }
    
    private func createCityToStationsMap(from response: Components.Schemas.StationsList) {
        cityToStationsMap.removeAll()
        
        if let countries = response.countries {
            for country in countries where country.title == "Россия" {
                if let regions = country.regions {
                    for region in regions {
                        if let settlements = region.settlements {
                            for settlement in settlements {
                                if let title = settlement.title, let stationsList = settlement.stations {
                                    var stationsForCity: [(title: String, code: String, stationType: String, transportType: String)] = []
                                    
                                    for station in stationsList {
                                        if let stationTitle = station.title, let code = station.codes?.yandex_code {
                                            stationsForCity.append((
                                                title: stationTitle,
                                                code: code,
                                                stationType: station.station_type ?? "Не указан",
                                                transportType: station.transport_type ?? "Не указан"
                                            ))
                                        }
                                    }
                                    
                                    if !stationsForCity.isEmpty {
                                        cityToStationsMap[title] = stationsForCity
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func processApiResponse(_ response: Components.Schemas.StationsList) {
        filterRussianCities(from: response)
        filterRussianStations(from: response)
        createCityToStationsMap(from: response)
    }
}
