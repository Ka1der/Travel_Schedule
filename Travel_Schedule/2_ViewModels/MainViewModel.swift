//
//  MainViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation
import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    @Published var isLoadingNearestSettlements: Bool = false
    @Published var showNearestSettlementAlert: Bool = false
    @Published var nearestSettlementMessage: String = ""
}
