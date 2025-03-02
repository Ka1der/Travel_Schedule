//
//  MainView.swift
//  Travel_Schedule
//
//  Created by Kaider on 23.02.2025.
//

import SwiftUI
import NavigationKit

struct MainView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var routeViewModel: RouteViewModel
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        TabView {
            VStack {
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<5) { _ in
                                StoriesView()
                                    .padding(.horizontal, 6)
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.leading, 16)
                    }
                    
                    
                    /*
                     Button(action: {
                     Task {
                     await mainViewModel.findNearestSettlements(
                     latitude: 59.864177,
                     longitude: 30.319163,
                     distance: 50
                     )
                     }
                     }) {
                     Label("Найти ближайшие города", systemImage: "location.circle.fill")
                     .padding()
                     .background(Color.blue.opacity(0.1))
                     .cornerRadius(10)
                     }
                     .position(x: geometry.size.width / 2, y: geometry.size.height - 500)
                     .alert("Результат поиска",
                     isPresented: $mainViewModel.showNearestSettlementAlert) {
                     Button("OK", role: .cancel) {}
                     } message: {
                     Text(mainViewModel.nearestSettlementMessage)
                     }
                     */
                    
                    RouteSearchFieldView()
                        .position(x: geometry.size.width / 2, y: geometry.size.height - 413)
                }
            }
            .tabItem {
                Label("", systemImage: "arrow.up.message.fill")
            }
            
            SettingsView()
                .tabItem {
                    Label("", systemImage: "gearshape.fill")
                }
        }
        .tint(.black)
    }
}

#Preview {
    MainView()
        .environmentObject(RouteViewModel())
        .environmentObject(MainViewModel())
        .environmentObject(NavigationKit.createNavigationManager())
}
