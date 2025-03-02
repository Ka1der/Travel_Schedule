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
    
    private let settlementService: NearestSettlementServiceProtocol
    
    init(settlementService: NearestSettlementServiceProtocol = ServiceManager.shared.createNearestSettlementService()) {
        self.settlementService = settlementService
    }
    
    @MainActor
    func findNearestSettlements(latitude: Double, longitude: Double, distance: Int) async {
        isLoadingNearestSettlements = true
        
        do {
            let settlement = try await settlementService.getNearestSettlement(
                lat: latitude,
                lng: longitude,
                distance: distance
            )
            
            if let settlementInfo = settlement.settlement {
                let distanceKm = settlementInfo.distance != nil ?
                    String(format: "%.2f км", Double(settlementInfo.distance!) / 1000.0) :
                    "неизвестное расстояние"
                
                nearestSettlementMessage = "Найден населенный пункт: \(settlementInfo.name ?? "Неизвестно") на расстоянии \(distanceKm)"
            } else {
                nearestSettlementMessage = "Населенные пункты не найдены в заданном радиусе"
            }
            
        } catch {
            nearestSettlementMessage = "Ошибка при поиске: \(error.localizedDescription)"
        }
        
        isLoadingNearestSettlements = false
        showNearestSettlementAlert = true
    }
}
