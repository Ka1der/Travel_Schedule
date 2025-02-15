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

protocol StationsListServiceProtocol {
    func getStationsList(
        apikey: String
    ) async throws -> StationsList
}

final class StationsListService: StationsListServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(
        client: Client,
        apikey: String
    ) {
        self.client = client
        self.apikey = apikey
    }
    
    func getStationsList(apikey: String) async throws -> StationsList {
        let urlString = "https://api.rasp.yandex.net/v3.0/stations_list/?apikey=\(apikey)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "InvalidURL", code: -1, userInfo: nil)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "HTTPError", code: -1, userInfo: nil)
        }
        
        guard httpResponse.mimeType == "application/json" else {
            let body = String(data: data, encoding: .utf8) ?? "Unable to decode response body"
            print("Unexpected content type. Response body: \(body)")
            throw NSError(domain: "ClientError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected content type"])
        }
        
        return try JSONDecoder().decode(StationsList.self, from: data)
    }
}
