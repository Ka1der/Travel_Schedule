//
//  RouteViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation
import SwiftUI
import Combine

final class RouteViewModel: ObservableObject {
    enum SelectionState {
        case from, to
    }
    
    @Published var fromPoint = RoutePoint()
    @Published var toPoint = RoutePoint()
    @Published var selectionState: SelectionState = .from
    @Published var canSearch: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Publishers.CombineLatest(
            $fromPoint.map { !$0.isEmpty },
            $toPoint.map { !$0.isEmpty }
        )
        .map { $0 && $1 }
        .assign(to: \.canSearch, on: self)
        .store(in: &cancellables)
    }
    
    func swapPoints() {
        (fromPoint, toPoint) = (toPoint, fromPoint)
    }
    
    var fromText: String { fromPoint.formattedText }
    var toText: String { toPoint.formattedText }
    
    func selectCity(_ city: String, for state: SelectionState) {
        switch state {
        case .from:
            fromPoint.city = city
        case .to:
            toPoint.city = city
        }
    }
    
    func selectStation(_ station: String, for state: SelectionState) {
        switch state {
        case .from:
            fromPoint.station = station
        case .to:
            toPoint.station = station
        }
    }
    
    func searchRoutes() {
        // Будущая реализация поиска маршрутов
    }
}
