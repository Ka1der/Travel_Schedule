//
//  Router.swift
//  Travel_Schedule
//
//  Created by Kaider on 24.02.2025.
//

import SwiftUI

@MainActor
final class Router: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func navigate(to destination: Route) {
        path.append(destination)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .mainScreen: MainView()
        case .choosingCity:  ChoosingCityView()
//        case .choosingStation:
//            <#code#>
//        case .carrierList:
//            <#code#>
//        case .carrierCard:
//            <#code#>
//        case .stories:
//            <#code#>
//        case .settings:
//            <#code#>
//        case .userAgreement:
//            <#code#>
        }
    }
}
