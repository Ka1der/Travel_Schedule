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
                    carrier.logoImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 38, height: 38)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: .gray.opacity(0.2), radius: 4)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(carrier.name)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(isDarkModeEnabled ? .white : .black)
                        
                        Text("С пересадкой в Костроме")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                            .opacity(0.7)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("12 января")
                            .font(.system(size: 12))
                            .foregroundColor(isDarkModeEnabled ? .white : .black)
                            .opacity(0.7)
                    }
                }
                
                HStack(spacing: 4) {
                    Text("22:30")
                        .font(.system(size: 17, weight: .regular))
                        .padding(.trailing, 4)
                    Rectangle()
                        .frame(width: 74.5, height: 1)
                            .foregroundColor(.gray)
                    Text("20 часов")
                        .font(.system(size: 12, weight: .regular))
                        .padding(.trailing, 5)
                        .padding(.leading, 5)
                    Rectangle()
                        .frame(width: 74.5, height: 1)
                            .foregroundColor(.gray)
                    Text("08:15")
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
        CarrierView(carrier: CarrierModel(name: "РЖД", logo: "rzdLogo2"))
            .environmentObject(NavigationManager())
    }
}
