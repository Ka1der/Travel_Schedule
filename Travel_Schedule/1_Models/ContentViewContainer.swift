//
//  ContentViewContainer.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import SwiftUI
import NavigationKit

struct ContentViewContainer: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationContainer(
            navigationManager: navigationManager,
            rootView: { ContentView() },
            destinationBuilder: { (screen: AppScreen) in screen.body }
        )
        .withNavigationModals(
            navigationManager: navigationManager,
            sheetContent: { (screen: ModalScreen) in screen.body },
            fullScreenCoverContent: { (screen: ModalScreen) in screen.body }
        )
    }
}
