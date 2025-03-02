//
//  CarrierModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation

struct CarrierModel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let logo: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    
    static func == (lhs: CarrierModel, rhs: CarrierModel) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
