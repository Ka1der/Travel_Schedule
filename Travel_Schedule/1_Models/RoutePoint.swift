//
//  RoutePoint.swift
//  Travel_Schedule
//
//  Created by Kaider on 09.03.2025.
//

import Foundation

struct RoutePoint: Sendable {
    enum PointType {
        case from, to
    }
    
    let type: PointType
    var city: String = ""
    var station: String = ""
    var code: String = ""
    var stationType: String = ""
    var transportType: String = ""
    
    var isEmpty: Bool {
        city.isEmpty || station.isEmpty || code.isEmpty
    }
    
    var formattedText: String {
        if isEmpty {
            return type == .from ? "Откуда" : "Куда"
        }
        return "\(city) - \(station)"
    }
}
