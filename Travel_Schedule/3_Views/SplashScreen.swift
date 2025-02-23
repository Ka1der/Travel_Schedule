//
//  SplashScreen.swift
//  Travel_Schedule
//
//  Created by Kaider on 06.02.2025.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if isActive {
                    TestView()
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

#Preview {
    SplashScreen()
}
