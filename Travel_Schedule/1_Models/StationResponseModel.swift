//
//  StationResponseModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 05.03.2025.
//

import Foundation

struct StationResponse: Codable {
    let stations: [Station]
}

struct Station: Codable {
    let code: String
    let title: String
    let shortTitle: String?
    let popularTitle: String?
    let type: String?
    let typeChoices: [String: [String: String]]
    let transportType: String?
    let stationType: String?
    let stationTypeName: String?
    let direction: String?
    let lat: Double
    let lng: Double
    let distance: Double?
    let majority: Int?
    
    enum CodingKeys: String, CodingKey {
        case code, title, type
        case shortTitle = "short_title"
        case popularTitle = "popular_title"
        case typeChoices = "type_choices"
        case transportType = "transport_type"
        case stationType = "station_type"
        case stationTypeName = "station_type_name"
        case direction, lat, lng, distance, majority
    }
}
