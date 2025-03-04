//
//  CarrierInfoView.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import SwiftUI
import NavigationKit

struct CarrierInfoView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @AppStorage("isDarkMode") private var isDarkModeEnabled: Bool = false
    
    var carrier: CarrierModel
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    navigationManager.navigateBack()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Информация о перевозчике")
                    .font(.headline)
                    .bold()
                Spacer()
                Image(systemName: "chevron.left")
                    .opacity(0)
            }
            .padding()
            
            VStack(spacing: 10) {
                Image("rzdLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 60)
                
                HStack {
                    Text("ОАО «РЖД»")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
            }
            
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("E-mail")
                            .font(.subheadline)
                        Link("i.lozgkina@yandex.ru",
                             destination: URL(string: "mailto:i.lozgkina@yandex.ru")!)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Телефон")
                            .font(.subheadline)
                        Link("+7 (904) 329-27-71",
                             destination: URL(string: "tel:+79043292771")!)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding()
        .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
    }
}

struct CarrierInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CarrierInfoView(carrier: CarrierModel(name: "ОАО «РЖД»", logo: "rzdLogo"))
            .environmentObject(NavigationKit.createNavigationManager())
    }
}
