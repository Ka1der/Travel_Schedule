//
//  CarrierViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation

class CarrierViewModel: ObservableObject {
    @Published var carriers: [CarrierModel] = [
        CarrierModel(name: "РЖД", logo: "rzdlogo"),
        CarrierModel(name: "Аэрофлот", logo: "aeroflotlogo"),
        CarrierModel(name: "S7 Airlines", logo: "s7logo"),
        CarrierModel(name: "Carrier 4", logo: "logo4"),
        CarrierModel(name: "Carrier 5", logo: "logo5")
    ]
}
