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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .frame(width: 343, height: 104)
                .foregroundStyle(Color.gray.opacity(0.3))
            VStack{
                Text(carrier.name)
                Text(carrier.logo)
            }
        }
        .onTapGesture {
            navigationManager.path.append(AppScreen.carrierInfo(carrier: carrier))
        }
    }
}

struct CarrierView_Previews: PreviewProvider {
    static var previews: some View {
        CarrierView(carrier: CarrierModel(name: "Sample Carrier", logo: "sampleLogo"))
            .environmentObject(NavigationKit.createNavigationManager())
    }
}
