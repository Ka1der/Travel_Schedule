//
//  ServiceManager.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import SwiftUI
import OpenAPIURLSession
import Combine

actor ServiceManager {
    
    // MARK: - Properties
    
    static let shared = ServiceManager()
    private var cancellables = Set<AnyCancellable>()
    private let networkMonitor = NetworkMonitor.shared
    
    private let nearestStationsService: NearestStationsService
    private let threadService: ThreadService
    private let stationsListService: StationsListService
    private let searchService: SearchListService
    private let scheduleService: ScheduleService
    private let nearestSettlementService: NearestSettlementService
    private let carrierService: CarrierService
    private let copyrightService: CopyrightService
    
    // MARK: - Initialization
    
    private init() {
        let client: Client
        do {
            client = try Client(
                serverURL: Servers.Server1.url(),
                transport: URLSessionTransport()
            )
        } catch {
            fatalError("Не удалось создать клиент API: \(error)")
        }
        
        nearestStationsService = NearestStationsService(client: client, apikey: Config.apiKey)
        threadService = ThreadService(client: client, apikey: Config.apiKey)
        stationsListService = StationsListService(client: client, apikey: Config.apiKey)
        searchService = SearchListService(client: client, apikey: Config.apiKey)
        scheduleService = ScheduleService(client: client, apikey: Config.apiKey)
        nearestSettlementService = NearestSettlementService(client: client, apikey: Config.apiKey)
        carrierService = CarrierService(client: client, apikey: Config.apiKey)
        copyrightService = CopyrightService(client: client, apikey: Config.apiKey)
        
        Task {
            await setupNetworkMonitoring()
        }
    }
    
    // MARK: - Network Monitoring
    
    private func setupNetworkMonitoring() async {
        let subscription = networkMonitor.connectionRestoredPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.handleNetworkReconnection()
                }
            }
        
        cancellables.insert(subscription)
    }
    
    // MARK: - Subscription Management
    
    func storeSubscription(_ cancellable: AnyCancellable) {
        cancellables.insert(cancellable)
    }
    
    nonisolated func setupSubscriptions(with viewModel: RouteViewModel) {
        let publisher = Publishers.CombineLatest(viewModel.$fromStationCode, viewModel.$toStationCode)
        let subscription = publisher.sink { fromCode, toCode in
            guard !fromCode.isEmpty, !toCode.isEmpty else { return }
            Task { @MainActor in
                await ServiceManager.shared.requestSearch(from: fromCode, to: toCode)
            }
        }
        
        Task {
            await ServiceManager.shared.storeSubscription(subscription)
        }
    }
    
    // MARK: - Network Handling
    
    private func handleNetworkReconnection() async {
        await requestStationsList()
    }
    
    private func handleResponseError(_ error: Error) {
        if let httpError = error as? HTTPURLResponse, httpError.statusCode >= 500 {
            ErrorManager.shared.showServerError()
            return
        }

        let nsError = error as NSError
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
        
        print("Ошибка запроса: \(error.localizedDescription)")
    }
    
    // MARK: - API Methods - Nearest Stations
    
    private func performNearestStationsRequest(for city: Config.Coordinates.City) async {
        do {
            let stationsResponse = try await nearestStationsService.getNearestStations(
                lat: city.lat,
                lng: city.lng,
                distance: Config.Coordinates.defaultSearchRadius
            )
            
            if let stations = stationsResponse.stations {
                printNearestStationsResult(city: city, stations: stations)
            }
        } catch {
            print("Ошибка при получении списка станций для города \(city.name): \(error)")
            handleResponseError(error)
        }
    }
    
    private func printNearestStationsResult(city: Config.Coordinates.City, stations: [Components.Schemas.Station]) {
        print("\nГород: \(city.name)")
        print("Получено станций: \(stations.count)\n")
        
        for (index, station) in stations.prefix(5).enumerated() {
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
    
    func requestNearestStations(for city: Config.Coordinates.City) {
        Task {
            await performNearestStationsRequest(for: city)
        }
    }
    
    func requestNearestStationsForAllCities() {
        for city in Config.Coordinates.cities {
            requestNearestStations(for: city)
        }
    }
    
    // MARK: - API Methods - Thread
    
    private func performThreadRequest() async {
        do {
            let thread = try await threadService.getThreadStations(uid: "068S_2_2")
            print(thread)
        } catch {
            print("Failed to fetch thread: \(error)")
            handleResponseError(error)
        }
    }
    
    func requestThread() {
        Task {
            await performThreadRequest()
        }
    }
    
    // MARK: - API Methods - Stations List
    
    private func performStationsListRequest() async {
        do {
            let stations = try await stationsListService.getStationsList(apikey: Config.apiKey)
            StationFilters.shared.processApiResponse(stations)
        } catch let error {
            print("Failed to fetch station list: \(error)")
            handleResponseError(error)
        }
    }
    
    func requestStationsList() {
        Task {
            await performStationsListRequest()
        }
    }
    
    // MARK: - API Methods - Search
    
    private func performSearchRequest(from: String, to: String, date: String?, transfers: Bool, carrierViewModel: CarrierViewModel?) async {
        let dateString = date ?? Config.SearchSettings.defaultDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let dateObject = dateFormatter.date(from: dateString) else {
            print("Invalid date string")
            return
        }
        
        do {
            let stations = try await searchService.getScheduleBetweenStations(
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
            handleResponseError(error)
        }
    }
    
    func requestSearch(from: String, to: String, date: String? = nil, transfers: Bool = false, carrierViewModel: CarrierViewModel? = nil) {
        Task {
            await performSearchRequest(from: from, to: to, date: date, transfers: transfers, carrierViewModel: carrierViewModel)
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
                    let threadInfo = """
                    
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
    
    // MARK: - API Methods - Schedule
    
    private func performScheduleRequest() async {
        let dateString = "2025-02-15"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date string")
            return
        }
        
        do {
            let stations = try await scheduleService.getScheduleOnStation(
                apikey: Config.apiKey,
                station: "s9600213",
                transportTypes: "train",
                date: date
            )
            print(stations)
        } catch {
            print("Failed to fetch schedule: \(error)")
            handleResponseError(error)
        }
    }
    
    func requestShedule() {
        Task {
            await performScheduleRequest()
        }
    }
    
    // MARK: - API Methods - Nearest Settlement
    
    private func performNearestSettlementRequest(for city: Config.Coordinates.City) async {
        do {
            let settlement = try await nearestSettlementService.getNearestSettlement(
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
            handleResponseError(error)
        }
    }
    
    func requestNearestSettlement(for city: Config.Coordinates.City) async {
        await performNearestSettlementRequest(for: city)
    }
    
    func requestNearestSettlementForAllCities() async {
        for city in Config.Coordinates.cities {
            await requestNearestSettlement(for: city)
        }
    }
    
    // MARK: - API Methods - Carrier
    
    func requestCarrierInfo(code: String) async throws -> Components.Schemas.Carrier {
        do {
            return try await carrierService.getCarrier(apikey: Config.apiKey, code: code)
        } catch let error {
            handleResponseError(error)
            throw error
        }
    }
    
    // MARK: - API Methods - Copyright
    
    private func performCopyrightRequest() async {
        do {
            let copyright = try await copyrightService.getCopyright(apikey: Config.apiKey)
            print(copyright)
        } catch {
            print("Failed to fetch copyright: \(error)")
            handleResponseError(error)
        }
    }
    
    func requestCopyright() {
        Task {
            await performCopyrightRequest()
        }
    }
}
