//
//  Travel_ScheduleApp.swift
//  Travel_Schedule
//
//  Created by Kaider on 06.02.2025.
//

import SwiftUI
import NavigationKit

@main
struct Travel_ScheduleApp: App {
    @StateObject private var routeViewModel = RouteViewModel()
    @StateObject private var mainViewModel = MainViewModel()
    @StateObject private var navigationManager = NavigationKit.createNavigationManager()
    @StateObject private var storyViewModel = StoryViewModel()
    @StateObject private var networkMonitor = NetworkMonitor.shared
    @AppStorage("isDarkMode") private var isDarkModeEnabled: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                SplashScreen()
                    .environmentObject(routeViewModel)
                    .environmentObject(mainViewModel)
                    .withNavigationManager(navigationManager)
                    .environmentObject(storyViewModel)
                    .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
                    .task {
                        ServiceManager.shared.setupSubscriptions(with: routeViewModel)
                        ServiceManager.shared.requestStationsList()
                    }
                
                if !networkMonitor.isConnected {
                    NoInternetVIew()
                        .environmentObject(navigationManager)
                        .transition(.opacity)
                        .zIndex(100) 
                }
            }
            .animation(.easeInOut, value: networkMonitor.isConnected)
        }
    }
}
