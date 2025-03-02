//
//  RouteViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation
import SwiftUI
import Combine

class RouteViewModel: ObservableObject {
    @Published var fromCity: String = ""
    @Published var toCity: String = ""
    @Published var fromStation: String = ""
    @Published var toStation: String = ""
    @Published var isSelectingFromCity: Bool = true
    @Published var canSearch: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Publishers.CombineLatest(
            $fromCity.map { !$0.isEmpty },
            $toCity.map { !$0.isEmpty }
        )
        .map { $0 && $1 }
        .assign(to: \.canSearch, on: self)
        .store(in: &cancellables)
    }
    
    func swapCities() {
        let tempCity = fromCity
        let tempStation = fromStation
        
        fromCity = toCity
        fromStation = toStation
        
        toCity = tempCity
        toStation = tempStation
    }
    
    func getFormattedFromText() -> String {
        if fromCity.isEmpty {
            return "Откуда"
        } else if fromStation.isEmpty {
            return fromCity
        } else {
            return "\(fromCity) (\(fromStation))"
        }
    }
    
    func getFormattedToText() -> String {
        if toCity.isEmpty {
            return "Куда"
        } else if toStation.isEmpty {
            return toCity
        } else {
            return "\(toCity) (\(toStation))"
        }
    }
    
    func selectCity(city: String, isFromCity: Bool) {
        if isFromCity {
            fromCity = city
        } else {
            toCity = city
        }
    }
    
    func selectStation(station: String, isFromCity: Bool) {
        if isFromCity {
            fromStation = station
        } else {
            toStation = station
        }
    }
    
    // Метод для поиска маршрутов (будет реализован позже)
    func searchRoutes() {
        // Здесь будет логика поиска маршрутов
    }
}
