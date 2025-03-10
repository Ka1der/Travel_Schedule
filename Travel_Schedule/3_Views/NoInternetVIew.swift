//
//  NoInternetVIew.swift
//  Travel_Schedule
//
//  Created by Kaider on 04.03.2025.
//

import SwiftUI
import NavigationKit

struct NoInternetVIew: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        
        VStack{
            Image("NoInternetImage")
                .resizable()
                .scaledToFit()
                .frame(width: 223, height: 223)
                .cornerRadius(70)
               
            Text("Нет интернета")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 16)
        }
    }
}

#Preview {
    NoInternetVIew()
        .environmentObject(NavigationManager())
}
