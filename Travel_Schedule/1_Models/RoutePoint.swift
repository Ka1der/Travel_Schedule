//
//  RoutePoint.swift
//  Travel_Schedule
//
//  Created by Kaider on 09.03.2025.
//

import Foundation

struct RoutePoint {
    var city: String = ""
    var station: String = ""
    
    var isEmpty: Bool { city.isEmpty }
    
    var formattedText: String {
        if city.isEmpty {
            return "Откуда"
        } else if station.isEmpty {
            return city
        } else {
            return "\(city) (\(station))"
        }
    }
}
