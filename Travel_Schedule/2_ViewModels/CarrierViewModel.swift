//
//  CarrierViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation

class CarrierViewModel: ObservableObject {
    @Published var carriers: [CarrierModel] = [
        CarrierModel(name: "РЖД", logo: "rzdLogo2"),
        CarrierModel(name: "ФГК", logo: "fgkLogo"),
        CarrierModel(name: "Урал логистика", logo: "uralLogistic"),
    ]
}
