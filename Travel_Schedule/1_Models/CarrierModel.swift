//
//  CarrierModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation
import SwiftUI

struct CarrierModel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let logo: Image
    
    init(name: String, logo: String) {
        self.name = name
        self.logo = Image(logo)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    
    static func == (lhs: CarrierModel, rhs: CarrierModel) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
