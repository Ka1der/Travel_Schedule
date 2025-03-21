//
//  SettingsView.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import SwiftUI
import NavigationKit

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section {
                        Toggle(isOn: $viewModel.isDarkModeEnabled) {
                            Text("Тёмная тема")
                        }
                        .tint(.blue)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                     
                        HStack {
                            Text("Пользовательское соглашение")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        .padding(.top)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.navigateToUserAgreement(navigationManager: navigationManager)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
                .padding()
                
                VStack {
                    Spacer()
                    
                    VStack {
                        Text(viewModel.apiInfo)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text("Версия приложения \(viewModel.appVersion)")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .preferredColorScheme(viewModel.isDarkModeEnabled ? .dark : .light)
    }
}

#Preview {
    SettingsView()
        .environmentObject(NavigationKit.createNavigationManager())
}
