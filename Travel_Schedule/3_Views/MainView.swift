//
//  MainView.swift
//  Travel_Schedule
//
//  Created by Kaider on 23.02.2025.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var router: Router
    
    var body: some View {

        NavigationStack(path: $router.path) {
            TabView {
                VStack{
                    GeometryReader { geometry in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<5){_ in
                                    StoriesViewModel()
                                        .padding(.horizontal, 6)
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.leading, 16)
                        }
                        RouteSearchFieldView()
                            .position(x: geometry.size.width / 2, y: geometry.size.height - 413)
                    }
                }
                .tabItem {
                    Label("", systemImage: "arrow.up.message.fill")
                }
                Text("Настройки")
                    .tabItem {
                        Label("", systemImage: "gearshape.fill")
                    }
            }
            .navigationDestination(for: Route.self) { route in
                router.view(for: route)
            }
        }
        .tint(.black)
    }
}


#Preview {
    MainView()
        .environmentObject(Router())
}
