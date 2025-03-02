//
//  CarrierViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation

class CarrierViewModel: ObservableObject {
    @Published var carriers: [CarrierModel] = [
        CarrierModel(name: "Carrier 1", logo: "logo1"),
        CarrierModel(name: "Carrier 2", logo: "logo2"),
        CarrierModel(name: "Carrier 3", logo: "logo3"),
        CarrierModel(name: "Carrier 4", logo: "logo4"),
        CarrierModel(name: "Carrier 5", logo: "logo5")
    ]
}
