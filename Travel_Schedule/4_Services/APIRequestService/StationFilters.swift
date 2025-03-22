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
    private var cityToStationsMap: [String: [String]] = [:]
    static let shared = StationFilters()
    
    // Добавляем Publisher для станций выбранного города
    let selectedCityStationsPublisher = PassthroughSubject<[String], Never>()
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
    
    // Фильтрация станций России
    func filterRussianStations(from response: Components.Schemas.StationsList) {
        var stations = [String]()
        
        if let countries = response.countries {
            for country in countries {
                if country.title == "Россия" {
                    if let regions = country.regions {
                        for region in regions {
                            if let settlements = region.settlements {
                                for settlement in settlements {
                                    if let stationsList = settlement.stations {
                                        for station in stationsList {
                                            if let title = station.title {
                                                stations.append(title)
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
        
        let uniqueStations = Array(Set(stations)).sorted()
        StationsStorage.shared.updateStations(uniqueStations)
        print("Станции России: \(uniqueStations.count)")
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
    
    func getStationsForCity(city: String) -> [String] {
        let stations = cityToStationsMap[city] ?? []
        return Array(Set(stations)).sorted()
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
                                    var stationsForCity: [String] = []
                                    
                                    for station in stationsList {
                                        if let stationTitle = station.title {
                                            stationsForCity.append(stationTitle)
                                        }
                                    }
                                    
                                    cityToStationsMap[title] = stationsForCity
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
