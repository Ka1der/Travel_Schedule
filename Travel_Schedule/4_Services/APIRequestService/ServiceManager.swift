//
//  ServiceManager.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation
import OpenAPIURLSession
import Combine

final class ServiceManager {
    
    static let shared = ServiceManager()
    
    private init() {
        
    }
    
    // MARK: - Nearest Stations
    
    func requestNearestStations(for city: Config.Coordinates.City) {
        do {
            let client = try Client(
                serverURL: Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = NearestStationsService(
                client: client,
                apikey: Config.apiKey
            )
            Task {
                do {
                    let stationsResponse = try await service.getNearestStations(
                        lat: city.lat,
                        lng: city.lng,
                        distance: Config.Coordinates.defaultSearchRadius
                    )
                    
                    if let stations = stationsResponse.stations {
                        print("\nГород: \(city.name)")
                        print("Получено станций: \(stations.count)\n")
                        
                        for (index, station) in stations.prefix(5).enumerated() { // prefix(10) - выводим 5 станций чтобы не перегружать консоль
                            print("""
                            Станция \(index + 1):
                            - Название: \(station.title)
                            - Код: \(station.code)
                            - Тип станции: \(station.station_type ?? "Не указан")
                            - Тип транспорта: \(station.transport_type ?? "Не указан")
                            - Координаты: \(station.lat), \(station.lng)
                            - Расстояние: \(String(format: "%.2f", station.distance ?? 0)) км
                            ----------------------------------------
                            """)
                        }
                    }
                } catch {
                    print("Ошибка при получении списка станций для города \(city.name): \(error)")
                }
            }
        } catch {
            print("Ошибка при создании клиента: \(error)")
        }
    }
    
    func requestNearestStationsForAllCities() {
        for city in Config.Coordinates.cities {
            requestNearestStations(for: city)
        }
    }
    
    // MARK: - Thread
    
    func requestThread() {
        do {
            let client = try Client(
                serverURL: Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = ThreadService(
                client: client,
                apikey: Config.apiKey
            )
            Task {
                do {
                    let thread = try await service.getThreadStations(
                        uid: "068S_2_2"
                    )
                    print(thread)
                } catch {
                    print("Failed to fetch thread: \(error)")
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
    
    // MARK: - Station List
    
    func requestStationsList() {
        do {
            let client = try Client(
                serverURL: Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = StationsListService(
                client: client,
                apikey: Config.apiKey
            )
            Task {
                do {
                    let stations = try await service.getStationsList(
                        apikey: Config.apiKey
                    )
//                    print(stations)
                    StationFilters.shared.processApiResponse(stations)
                } catch {
                    print("Failed to fetch station list: \(error)")
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
    
    // MARK: - Search
    
    func requestSearch() {
        do {
            let client = try Client(
                serverURL: Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = SearchListService(
                client: client,
                apikey: Config.apiKey
            )
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: Config.SearchSettings.defaultDate) else {
                print("Некорректная дата")
                return
            }
            
            Task {
                for route in Config.SearchSettings.defaultRoutes {
                    do {
                        print("Поиск маршрута: \(route.name)")
                        let stations = try await service.getScheduleBetweenStations(
                            apikey: Config.apiKey,
                            from: route.from,
                            to: route.to,
                            transportTypes: route.transportType,
                            date: date
                        )
                        printSearchResults(stations)
                    } catch {
                        print("Ошибка при поиске маршрута \(route.name): \(error)")
                    }
                }
            }
        } catch {
            print("Ошибка при создании клиента: \(error)")
        }
    }

    private func printSearchResults(_ stations: Components.Schemas.Search) {
        print("Расписание рейсов между станциями")
        
        print("Откуда:")
        if let from = stations.search?.from {
            print("- Код: \(from.code ?? "Не указан")")
            print("- Название: \(from.title ?? "Не указано")")
            print("- Тип: \(from._type ?? "Не указан")")
        }
        
        print("\nКуда:")
        if let to = stations.search?.to {
            print("- Код: \(to.code ?? "Не указан")")
            print("- Название: \(to.title ?? "Не указано")")
            print("- Тип: \(to._type ?? "Не указан")")
            print("- Тип транспорта: \(to.transport_type ?? "Не указан")")
            print("- Тип станции: \(to.station_type ?? "Не указан")")
            print("- Название типа станции: \(to.station_type_name ?? "Не указано")")
        }
    }
    
    // MARK: - Shedule
    
    func requestShedule() {
        do {
            let client = try Client(
                serverURL: Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = ScheduleService(
                client: client,
                apikey: Config.apiKey
            )
            
            let dateString = "2025-02-15"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: dateString) else {
                print("Invalid date string")
                return
            }
            
            Task {
                do {
                    let stations = try await service.getScheduleOnStation(
                        apikey: Config.apiKey,
                        station: "s9600213",
                        transportTypes: "train",
                        date: date
                    )
                    print(stations)
                } catch {
                    print("Failed to fetch schedule: \(error)")
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
    
    // MARK: - Nearest Settlement
    
    func requestNearestSettlement(for city: Config.Coordinates.City) async {
        do {
            let client = try Client(
                serverURL: Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = NearestSettlementService(
                client: client,
                apikey: Config.apiKey
            )
            
            Task {
                do {
                    let settlement = try await service.getNearestSettlement(
                        lat: city.lat,
                        lng: city.lng,
                        distance: Config.Coordinates.defaultSearchRadius
                    )
                    print("----------------------------------------")
                    print("""
                    - Название: \(settlement.title)
                    - Код: \(settlement.code ?? "Не указан")
                    - Координаты: \(settlement.lat), \(settlement.lng)
                    - Расстояние: \(String(format: "%.2f", settlement.distance ?? 0)) км
                    ----------------------------------------
                    """)
                } catch {
                    print("Ошибка при получении ближайшего населенного пункта для города \(city.name): \(error)")
                }
            }
        } catch {
            print("Ошибка при создании клиента: \(error)")
        }
    }
    
    func requestNearestSettlementForAllCities() async {
        for city in Config.Coordinates.cities {
            await requestNearestSettlement(for: city)
        }
    }
    
    // MARK: - Carrier
    
    func requestCarrier() {
        do {
            let client = try Client(
                serverURL: Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = CarrierService(
                client: client,
                apikey: Config.apiKey
            )
            Task {
                do {
                    let stations = try await service.getCarrier(
                        apikey: Config.apiKey,
                        code: "5483"
                    )
                    print(stations)
                } catch {
                    print("Failed to fetch carrier: \(error)")
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
    
    // MARK: - Copyright
    
    func requestCopyright() {
        do {
            let client = try Client(
                serverURL: Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = CopyrightService(
                client: client,
                apikey: Config.apiKey
            )
            Task {
                do {
                    let stations = try await service.getCopyright(
                        apikey: Config.apiKey
                    )
                    print(stations)
                } catch {
                    print("Failed to fetch copyright: \(error)")
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
}
