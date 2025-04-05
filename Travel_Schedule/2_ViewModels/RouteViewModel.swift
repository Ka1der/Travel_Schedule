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
    @Published var searchResults: Components.Schemas.Search?
    @Published var isSearching: Bool = false
    @Published var searchError: Error?
    @Published private(set) var fromStationCode: String = ""
    @Published private(set) var toStationCode: String = ""
    private let serviceManager = ServiceManager.shared
    
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
    
    func selectStation(_ station: (
        title: String,
        code: String,
        stationType: String,
        transportType: String
    ), for state: SelectionState) {
        print("""
            Выбрана станция:
            - Название: \(station.title)
            - Код: \(station.code)
            - Тип станции: \(station.stationType)
            - Тип транспорта: \(station.transportType)
            Для: \(state)
            """)
        
        switch state {
        case .from:
            fromPoint.station = station.title
            fromPoint.code = station.code
            fromPoint.stationType = station.stationType
            fromPoint.transportType = station.transportType
            fromStationCode = station.code
        case .to:
            toPoint.station = station.title
            toPoint.code = station.code
            toPoint.stationType = station.stationType
            toPoint.transportType = station.transportType
            toStationCode = station.code
        }
    }
    
    func searchRoutes() {
        guard canSearch else { return }
        print("""
            Поиск маршрутов:
            От: \(fromPoint.city) (\(fromPoint.station))
            - Тип станции: \(fromPoint.stationType)
            - Тип транспорта: \(fromPoint.transportType)
            До: \(toPoint.city) (\(toPoint.station))
            - Тип станции: \(toPoint.stationType)
            - Тип транспорта: \(toPoint.transportType)
            Коды станций: \(fromPoint.code) -> \(toPoint.code)
            """)
    }
}
