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
    
    @Published var fromPoint = RoutePoint(type: .from)
    @Published var toPoint = RoutePoint(type: .to)
    @Published var selectionState: SelectionState = .from
    @Published var canSearch: Bool = false
    @Published var selectedCity: String = ""
    
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
    
    func selectStation(_ station: (title: String, code: String), for state: SelectionState) {
        print("Выбрана станция \(station.title) (код: \(station.code)) для \(state)")
        switch state {
        case .from:
            fromPoint.station = station.title
            fromPoint.code = station.code
        case .to:
            toPoint.station = station.title
            toPoint.code = station.code
        }

    }
    
    func searchRoutes() {
        guard canSearch else { return }
        print("Поиск маршрутов от \(fromPoint.city) (\(fromPoint.station)) до \(toPoint.city) (\(toPoint.station))")
        print("Коды станций: \(fromPoint.code) -> \(toPoint.code)")
        
        // реализация поиска маршрутов
    }
}
