//
//  ContentView.swift
//  TestNavigation
//
//  Created by Kaider on 27.02.2025.
//

import SwiftUI
import NavigationKit

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var routeViewModel: RouteViewModel
    private let serviceManager = ServiceManager.shared
    
    var body: some View {
        MainView()
            .task {
                ServiceManager.shared.requestStationsList()
            }
    }
}

#Preview {
    ContentView()
        .environmentObject(RouteViewModel())
        .environmentObject(MainViewModel())
        .environmentObject(NavigationKit.createNavigationManager())
}
