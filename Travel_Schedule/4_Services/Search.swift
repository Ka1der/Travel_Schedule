//
//  Search.swift
//  Travel_Schedule
//
//  Created by Kaider on 09.02.2025.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Search = Components.Schemas.Search

protocol SearchServiceProtocol {
    func getScheduleBetweenStations(
        apikey: String,
        from: String,
        to: String,
        transportTypes: String,
        date: Date
    ) async throws -> Search
}

final class SearchListService: SearchServiceProtocol {
    private let client: Client
    private let apikey: String
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init(
        client: Client,
        apikey: String
    ) {
            self.client = client
            self.apikey = apikey
        }
    
    func getScheduleBetweenStations(
        apikey: String,
        from: String,
        to: String,
        transportTypes: String,
        date: Date
    ) async throws -> Search {
        
        let dateString = dateFormatter.string(from: date)
        let response = try await client.getScheduleBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            transport_types: transportTypes,
            date: dateString
        ))
        return try response.ok.body.json
    }
}
