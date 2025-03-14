//
//  RoutePoint.swift
//  Travel_Schedule
//
//  Created by Kaider on 09.03.2025.
//

import Foundation

struct RoutePoint {
    enum PointType {
        case from, to
        
        var defaultText: String {
            switch self {
            case .from: return "Откуда"
            case .to: return "Куда"
            }
        }
    }
    
    var city: String = ""
    var station: String = ""
    let type: PointType
    
    var isEmpty: Bool { city.isEmpty }
    
    var formattedText: String {
        if city.isEmpty {
            return type.defaultText
        } else if station.isEmpty {
            return city
        } else {
            return "\(city) (\(station))"
        }
    }
    
    init(type: PointType = .from) {
        self.type = type
    }
}
