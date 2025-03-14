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
    @AppStorage("isDarkMode") private var isDarkModeEnabled: Bool = false
    private let serviceManager = ServiceManager.shared
    
    var body: some View {
        
        TabView {
                   VStack {
                       GeometryReader { geometry in
                           ScrollView(.horizontal, showsIndicators: false) {
                               HStack {
                                   ForEach(0..<5) { _ in
                                       StoriesSmallView()
                                           .padding(.horizontal, 6)
                                   }
                                   .onTapGesture {
                                       navigationManager.path.append(AppScreen.storiesLargeView)
                                   }
                               }
                               .padding(.vertical, 10)
                               .padding(.leading, 16)
                           }
                           
                           RouteSearchFieldView()
                               .position(x: geometry.size.width / 2, y: geometry.size.height - 413)
                           
                           VStack {
                               if !routeViewModel.fromPoint.isEmpty && !routeViewModel.toPoint.isEmpty {
                                   Button(action: {
                                       navigationManager.path.append(AppScreen.carrierList)
                                   }) {
                                       Text("Найти")
                                           .frame(width: 150, height: 60)
                                           .fontWeight(.bold)
                                           .font(.system(size: 17))
                                           .background(Color.blue)
                                           .foregroundColor(.white)
                                           .cornerRadius(16)
                                   }
                                   .transition(.opacity)
                               }
                           }
                           .position(x: geometry.size.width / 2, y: (geometry.size.height - 413 + 110))
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
        .tint(isDarkModeEnabled ? .white : .black)
        .task {
            await serviceManager.requestNearestSettlementForAllCities()
            //                                serviceManager.requestNearestStationsForAllCities()
            //                                serviceManager.requestThread() // проверить
            //                                serviceManager.requestStationsList()
            //                                serviceManager.requestSearch()
            //                                serviceManager.requestShedule()
            //                                serviceManager.requestCarrier() // проверить
            //                                serviceManager.requestCopyright() // проверить
        }
    }
}

#Preview {
    MainView()
    
        .environmentObject(RouteViewModel())
        .environmentObject(MainViewModel())
        .environmentObject(NavigationKit.createNavigationManager())
}
