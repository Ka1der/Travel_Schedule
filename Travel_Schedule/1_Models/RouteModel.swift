//
//  RouteModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 01.03.2025.
//

import SwiftUI

class RouteModel: ObservableObject {
    @Published var fromCity: String = ""
    @Published var toCity: String = ""
    @Published var fromStations: String = ""
    @Published var toStations: String = ""
    @Published var isSelectingFromCity: Bool = true
}
