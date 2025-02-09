//
//  StationsList.swift
//  Travel_Schedule
//
//  Created by Kaider on 09.02.2025.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias StationsList = Components.Schemas.StationsList

protocol StationListServiceProtocol {
    func getStationList(
        apikey: String)
    async throws -> StationsList
}

final class StationListService: StationListServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(
        client: Client,
        apikey: String) {
            self.client = client
            self.apikey = apikey
        }
    
    func getStationList(apikey: String) async throws -> StationsList {
        let response = try await client.getStationList(query: .init(
            apikey: apikey
        ))
        return try response.ok.body.json
    }
}
