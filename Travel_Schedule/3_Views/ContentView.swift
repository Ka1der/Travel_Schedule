//
//  ContentView.swift
//  TestNavigation
//
//  Created by Kaider on 27.02.2025.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var routeModel: RouteModel
    
    var body: some View {
          NavigationStack(path: $router.path) {
              MainView()
                  .navigationDestination(for: Screens.self) { screen in
                      screen.view
                  }
          }
      }
  }

#Preview {
    ContentView()
        .environmentObject(Router())
}
