//
//  SplashScreen.swift
//  Travel_Schedule
//
//  Created by Kaider on 06.02.2025.
//

import SwiftUI

struct SplashScreen: View {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var routeModel: RouteModel
    @State private var isActive = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if isActive {
                    ContentView()
                        .environmentObject(router)
                        .environmentObject(routeModel)
                } else {
                    Image("SplashScreen")
                        .resizable()
                        .ignoresSafeArea()
                }
            }
            .navigationBarHidden(true)
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

struct MainScreen: View {
    var body: some View {
        Text("Главный экран")
    }
}

//#Preview {
//    SplashScreen()
//}
