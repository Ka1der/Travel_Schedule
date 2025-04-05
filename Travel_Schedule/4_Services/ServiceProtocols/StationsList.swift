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
            throw NSError(domain: "HTTPError", code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                          userInfo: [NSLocalizedDescriptionKey: "HTTP error with status: \((response as? HTTPURLResponse)?.statusCode ?? -1)"])
        }
    
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(StationsList.self, from: data)
        } catch {
            let bodyPreview = String(data: data.prefix(100), encoding: .utf8) ?? "Unable to decode response"
            throw NSError(domain: "ClientError",
                          code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "JSON decoding failed: \(error.localizedDescription). Response preview: \(bodyPreview)..."])
        }
    }
}
