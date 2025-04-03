//
//  CarrierInfoView.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import SwiftUI
import NavigationKit

struct CarrierInfoView: View {
    @StateObject private var viewModel = CarrierInfoViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    @AppStorage("isDarkMode") private var isDarkModeEnabled: Bool = false
    
    var carrier: CarrierModel
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                if let logo = viewModel.carrier?.logo, !logo.isEmpty {
                    AsyncImage(url: URL(string: logo)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 343, height: 104)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                
                HStack {
                    Text(viewModel.carrier?.title ?? carrier.name)
                        .font(.system(size: 24))
                        .bold()
                    Spacer()
                }
            }
            .padding(.top, 16)
            
            if viewModel.isLoading {
                ProgressView("Загрузка...")
                    .padding()
                Spacer()
            } else {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("E-mail")
                                .font(.subheadline)
                            
                            if !viewModel.email.isEmpty {
                                if let emailURL = URL(string: "mailto:\(viewModel.email)") {
                                    Link(viewModel.email, destination: emailURL)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                } else {
                                    Text(viewModel.email)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                            } else {
                                Text("Нет данных")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Телефон")
                                .font(.subheadline)
                            
                            if !viewModel.phone.isEmpty {
                                let cleanPhone = viewModel.phone.replacingOccurrences(of: " ", with: "")
                                if let phoneURL = URL(string: "tel:\(cleanPhone)") {
                                    Link(viewModel.phone, destination: phoneURL)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                } else {
                                    Text(viewModel.phone)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                            } else {
                                Text("Нет данных")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            navigationManager.navigateBack()
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isDarkModeEnabled ? .white : .black)
        })
        .onAppear {
            if let code = carrier.code, code > 0 {
                viewModel.loadCarrierInfo(code: code)
            }
        }
    }
}

struct CarrierInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CarrierInfoView(carrier: CarrierModel(name: "ОАО «РЖД»", logo: "rzdLogo"))
            .environmentObject(NavigationManager())
    }
}
