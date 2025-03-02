//
//  SettingsView.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import SwiftUI
import NavigationKit

struct SettingsView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var isDarkModeEnabled = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section {
                        Toggle(isOn: $isDarkModeEnabled) {
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
                            
                            navigationManager.navigate(to: AppScreen.userAgreementView)
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
                        Text("Приложение использует API \"Яндекс.Расписания\"")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text("Версия приложения 1.0 (beta)")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                    .padding(.bottom, 16)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(NavigationKit.createNavigationManager())
}
