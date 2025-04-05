//
//  UserAgreementView.swift
//  Travel_Schedule
//
//  Created by Kaider on 21.03.2025.
//

import SwiftUI
import NavigationKit

struct UserAgreementView: View {
    @StateObject private var viewModel = UserAgreementViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.agreementTitle)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(viewModel.isDarkModeEnabled ? .white : .black)
                        .padding(.bottom, 8)
                        
                    Text(viewModel.agreementVersion)
                        .font(.system(size: 14))
                        .foregroundColor(viewModel.isDarkModeEnabled ? .white : .black)
                        .padding(.bottom, 16)
                    
                    Text(viewModel.fullAgreementText)
                        .font(.system(size: 14))
                        .foregroundColor(viewModel.isDarkModeEnabled ? .white : .black)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 30)
            }
        }
        .background(Color(.systemBackground))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            viewModel.navigateBack(navigationManager: navigationManager)
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(viewModel.isDarkModeEnabled ? .white : .black)
        })
        .navigationBarTitle("Пользовательское соглашение", displayMode: .inline)
    }
}

#Preview {
    UserAgreementView()
        .environmentObject(NavigationKit.createNavigationManager())
}
