//
//  ServiceManager.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import SwiftUI
import OpenAPIURLSession
import Combine

final class ServiceManager {
    
    static let shared = ServiceManager()
    private var cancellables = Set<AnyCancellable>()
    private let networkMonitor = NetworkMonitor.shared
    
    private init() {
        networkMonitor.connectionRestoredPublisher
            .sink { [weak self] _ in
                self?.handleNetworkReconnection()
            }
            .store(in: &cancellables)
    }
    
    func setupSubscriptions(with viewModel: RouteViewModel) {
        Publishers.CombineLatest(viewModel.$fromStationCode, viewModel.$toStationCode)
            .sink { [weak self] fromCode, toCode in
                guard !fromCode.isEmpty, !toCode.isEmpty else { return }
                self?.requestSearch(from: fromCode, to: toCode)
            }
            .store(in: &cancellables)
    }
    
    private func handleNetworkReconnection() {
        requestStationsList()
    }
    
    private func handleResponseError(_ error: Error) {

        if let httpError = error as? HTTPURLResponse, httpError.statusCode >= 500 {
            ErrorManager.shared.showServerError()
            return
        }

        if let nsError = error as? NSError {
          
            let criticalCodes = [
                NSURLErrorCannotDecodeContentData,
                NSURLErrorCannotParseResponse,
                NSURLErrorBadServerResponse,
                NSURLErrorCannotConnectToHost
            ]
            
            if criticalCodes.contains(nsError.code) {
                ErrorManager.shared.showServerError()
                return
            }
        }
        print("Ошибка запроса: \(error.localizedDescription)")
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
                } catch let error {
                    print("Failed to fetch station list: \(error)")
                    handleResponseError(error)
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
    
    // MARK: - Search
    
    func requestSearch(from: String, to: String, date: String? = nil, transfers: Bool = false, carrierViewModel: CarrierViewModel? = nil) {
        do {
            let client = try Client(
                serverURL: Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = SearchListService(
                client: client,
                apikey: Config.apiKey
            )
            
            let dateString = date ?? Config.SearchSettings.defaultDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let dateObject = dateFormatter.date(from: dateString) else {
                print("Invalid date string")
                return
            }
            
            Task {
                do {
                    let stations = try await service.getScheduleBetweenStations(
                        apikey: Config.apiKey,
                        from: from,
                        to: to,
                        transportTypes: "train",
                        date: dateObject,
                        transfers: transfers
                    )
                    
                    if let vm = carrierViewModel {
                        vm.updateCarriers(from: stations)
                    }
                    
                    printSearchResults(stations)
                } catch {
                    DispatchQueue.main.async {
                        carrierViewModel?.isLoading = false
                        carrierViewModel?.errorMessage = "Ошибка при загрузке данных: \(error.localizedDescription)"
                    }
                    print("Ошибка при поиске маршрута: \(error)")
                }
            }
        } catch {
            print("Ошибка при создании клиента: \(error)")
            DispatchQueue.main.async {
                carrierViewModel?.isLoading = false
                carrierViewModel?.errorMessage = "Ошибка при создании клиента"
            }
        }
    }
    
    private func formatDateObject(_ date: Date?) -> String {
        guard let date = date else { return "Не указано" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        
        return outputFormatter.string(from: date)
    }
    
    private func printSearchResults(_ stations: Components.Schemas.Search) {
        print("\nРасписание рейсов между станциями:")
        
        if let from = stations.search?.from {
            print("""
            Откуда: 
            - Название: \(from.title ?? "Не указано")
            - Код: \(from.code ?? "Не указан")
            - Тип транспорта: \(from.transport_type ?? "Не указан")
            """)
        } else {
            print("Откуда: Информация отсутствует")
        }
        
        if let to = stations.search?.to {
            print("""
            Куда:
            - Название: \(to.title ?? "Не указано")
            - Код: \(to.code ?? "Не указан")
            - Тип транспорта: \(to.transport_type ?? "Не указан")
            """)
        } else {
            print("Куда: Информация отсутствует")
        }
        
        if let segments = stations.segments {
            if segments.isEmpty {
                print("\nРейсы не найдены")
            } else {
                print("\nНайденные рейсы:")
                for (index, segment) in segments.enumerated() {
                    var threadInfo = """
                    
                    Рейс #\(index + 1):
                    - Номер рейса: \(segment.thread?.number ?? "Не указан")
                    - Перевозчик: \(segment.thread?.carrier?.title ?? "Не указан")
                    - Код перевозчика: \(segment.thread?.carrier?.code.map { String(describing: $0) } ?? "Не указан")
                    - Тип транспорта: \(segment.thread?.transport_type ?? "Не указан")
                    """
                    
                    print(threadInfo)
                }
            }
        } else {
            print("\nРейсы не найдены")
        }
        print("----------------------------------------")
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
    
    func requestCarrierInfo(code: String) async throws -> Components.Schemas.Carrier {
        do {
        let client = try Client(
            serverURL: Servers.Server1.url(),
            transport: URLSessionTransport()
        )
        
        let service = CarrierService(
            client: client,
            apikey: Config.apiKey
        )

        let carrierInfo = try await service.getCarrier(
            apikey: Config.apiKey,
            code: code
        )
        
        return carrierInfo
        } catch let error {
              handleResponseError(error)
              throw error
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
