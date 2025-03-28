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
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    CarrierLogoView(logoSource: carrier.logoSource)
                        .frame(width: 60, height: 60)
                    
                    Text(carrier.name)
                        .font(.title3)
                        .bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
                
                if let departureTime = carrier.departureTime,
                   let arrivalTime = carrier.arrivalTime,
                   let duration = carrier.duration {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Информация о рейсе")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        HStack {
                            Text("Отправление:")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(departureTime)
                                .bold()
                        }
                        
                        HStack {
                            Text("Прибытие:")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(arrivalTime)
                                .bold()
                        }
                        
                        HStack {
                            Text("Длительность:")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(TimeFormatter.formatDuration(minutes: duration))
                                .bold()
                        }
                        
                        if let tripDate = carrier.tripDate {
                            HStack {
                                Text("Дата поездки:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(tripDate)
                                    .bold()
                            }
                        }
                        
                        if carrier.hasTransfer, let location = carrier.transferLocation {
                            HStack {
                                Text("Пересадка:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(location)
                                    .foregroundColor(.red)
                                    .bold()
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(uiColor: .systemGray6))
                    )
                }
                
                // Контактная информация
                VStack(alignment: .leading, spacing: 16) {
                    Text("Контактная информация")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    HStack {
                        Text("E-mail:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Link("i.lozgkina@yandex.ru",
                             destination: URL(string: "mailto:i.lozgkina@yandex.ru")!)
                        .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("Телефон:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Link("+7 (904) 329-27-71",
                             destination: URL(string: "tel:+79043292771")!)
                        .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .systemGray6))
                )
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("О перевозчике")
        .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            navigationManager.navigateBack()
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isDarkModeEnabled ? .white : .black)
        })
    }
}

struct CarrierInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CarrierInfoView(carrier: CarrierModel(name: "ОАО «РЖД»", logo: "rzdLogo"))
            .environmentObject(NavigationKit.createNavigationManager())
    }
}
