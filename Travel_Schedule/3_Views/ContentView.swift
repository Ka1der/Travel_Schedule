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
    
    var body: some View {
        MainView()
    }
}
