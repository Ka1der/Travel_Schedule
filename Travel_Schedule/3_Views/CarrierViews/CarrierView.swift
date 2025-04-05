//
//  CarrierView.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import SwiftUI
import NavigationKit

struct CarrierView: View {
    let carrier: CarrierModel
    @EnvironmentObject var navigationManager: NavigationManager
    @AppStorage("isDarkMode") private var isDarkModeEnabled: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .frame(maxWidth: .infinity)
                .frame(height: 104)
                .foregroundStyle(Color(uiColor: .systemGray5))
            
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    CarrierLogoView(logoSource: carrier.logoSource)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(carrier.name)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(isDarkModeEnabled ? .white : .black)
                        
                        if carrier.hasTransfer, let location = carrier.transferLocation {
                               Text("С пересадкой в \(location)")
                                   .font(.system(size: 12))
                                   .foregroundColor(.red)
                                   .opacity(0.7)
                           }
                       }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(carrier.tripDate ?? "12 января")
                            .font(.system(size: 12))
                            .foregroundColor(isDarkModeEnabled ? .white : .black)
                            .opacity(0.7)
                    }
                }
                
                HStack(spacing: 4) {
                    Text(carrier.departureTime ?? "--:--")
                        .font(.system(size: 17, weight: .regular))
                        .padding(.trailing, 4)
                    Rectangle()
                        .frame(width: 74.5, height: 1)
                        .foregroundColor(.gray)
                    Text(TimeFormatter.formatDuration(minutes: carrier.duration ?? 0))
                        .font(.system(size: 12, weight: .regular))
                        .lineLimit(1)
                        .padding(.trailing, 5)
                        .padding(.leading, 5)
                    Rectangle()
                        .frame(width: 74.5, height: 1)
                        .foregroundColor(.gray)
                    Text(carrier.arrivalTime ?? "--:--")
                        .font(.system(size: 17, weight: .regular))
                        .padding(.leading, 4)
                }
                .foregroundColor(isDarkModeEnabled ? .white : .black)
            }
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, 16)
    }
}

struct CarrierView_Previews: PreviewProvider {
    static var previews: some View {
        CarrierView(carrier: CarrierModel(name: "РЖД", logo: "rzdLogo2", hasTransfer: true, transferLocation: "Кострома"))
            .environmentObject(NavigationManager())
    }
}
