//
//  SplashScreen.swift
//  Travel_Schedule
//
//  Created by Kaider on 06.02.2025.
//

import SwiftUI
import NavigationKit

struct SplashScreen: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var routeModel: RouteViewModel
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            if isActive {
                ContentViewContainer()
                    .environmentObject(routeModel)
            } else {
                Image("SplashScreen")
                    .resizable()
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
        .environmentObject(RouteViewModel())
        .environmentObject(NavigationKit.createNavigationManager())
}
