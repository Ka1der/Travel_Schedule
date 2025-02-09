//
//  Schedule.swift
//  Travel_Schedule
//
//  Created by Kaider on 09.02.2025.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleList = Components.Schemas.Schedule

protocol ScheduleServiceProtocol {
    func getScheduleOnStation(
        apikey: String,
        station: String,
        transportTypes: String,
        date: Date)
    async throws -> ScheduleList
}

final class ScheduleService: ScheduleServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleOnStation(
        apikey: String,
        station: String,
        transportTypes:
        String, date: Date
    ) async throws -> ScheduleList {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let response = try await client.getScheduleOnStation(query: .init(
            apikey: apikey,
            station: station,
            transport_types: transportTypes,
            date: dateString
        ))
        return try response.ok.body.json
    }
}

