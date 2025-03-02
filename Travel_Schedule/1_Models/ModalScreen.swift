//
//  ModalScreen.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import SwiftUI
import NavigationKit

enum ModalScreen: Screen, Hashable, Identifiable {
    case settings
    case info(message: String)
    
    var id: String {
        switch self {
        case .settings:
            return "settings"
        case .info(let message):
            return "info-\(message)"
        }
    }
    
    var body: some View {
        switch self {
        case .settings:
            Text("Настройки")
                .navigationTitle("Настройки")
        case .info(let message):
            VStack {
                Text("Информация")
                    .font(.title)
                Text(message)
                    .padding()
            }
        }
    }
}
