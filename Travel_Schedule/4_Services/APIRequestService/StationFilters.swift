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
    static let shared = StationFilters()
    
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
    
    func processApiResponse(_ response: Components.Schemas.StationsList) {
        filterRussianCities(from: response)
        filterRussianStations(from: response)
    }
}
