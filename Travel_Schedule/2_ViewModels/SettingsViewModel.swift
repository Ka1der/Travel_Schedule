//
//  SettingsViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 21.03.2025.
//

import SwiftUI
import NavigationKit
import Combine

final class SettingsViewModel: ObservableObject {
    @AppStorage("isDarkMode") var isDarkModeEnabled: Bool = false
    
    let appVersion = "1.0 (beta)"
    let apiInfo = "Приложение использует API \"Яндекс.Расписания\""
    
    @MainActor
    func navigateToUserAgreement(navigationManager: NavigationManager) {
        navigationManager.navigate(to: AppScreen.userAgreementView)
    }
}
