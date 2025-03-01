//
//  Router.swift
//  Travel_Schedule
//
//  Created by Kaider on 24.02.2025.
//

import SwiftUI

enum Screens: Hashable {
    case mainScreen
    case choosingCity
    case choosingStation
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .mainScreen: MainView()
        case .choosingCity:  ChoosingCityView()
        case .choosingStation:  ChoosingStationsView()
        }
    }
}

@MainActor
final class Router: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func navigate(to destination: Screens) {
        path.append(destination)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
}



