//
//  ServiceManager.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation
import OpenAPIURLSession

final class ServiceManager {
    static let shared = ServiceManager()
    
    private let client: Client
    
    private init() {
        do {
            self.client = try Client(
                serverURL: Servers.Server1.url(),
                transport: URLSessionTransport()
            )
        } catch {
            fatalError("Не удалось создать API клиент: \(error)")
        }
    }
    
    func createNearestStationsService() -> NearestStationsServiceProtocol {
        return NearestStationsService(client: client, apikey: Config.apiKey)
    }
    
    func createThreadService() -> ThreadServiceProtocol {
        return ThreadService(client: client, apikey: Config.apiKey)
    }
    
    func createStationsListService() -> StationsListServiceProtocol {
        return StationsListService(client: client, apikey: Config.apiKey)
    }
    
    func createSearchService() -> SearchServiceProtocol {
        return SearchListService(client: client, apikey: Config.apiKey)
    }
    
    func createScheduleService() -> ScheduleServiceProtocol {
        return ScheduleService(client: client, apikey: Config.apiKey)
    }
    
    func createNearestSettlementService() -> NearestSettlementServiceProtocol {
        return NearestSettlementService(client: client, apikey: Config.apiKey)
    }
    
    func createCarrierService() -> CarrierServiceProtocol {
        return CarrierService(client: client, apikey: Config.apiKey)
    }
    
    func createCopyrightService() -> CopyrightServiceProtocol {
        return CopyrightService(client: client, apikey: Config.apiKey)
    }
}
