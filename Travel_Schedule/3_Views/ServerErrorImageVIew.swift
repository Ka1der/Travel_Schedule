//
//  ServerErrorView.swift
//  Travel_Schedule
//
//  Created by Kaider on 04.03.2025.
//

import SwiftUI
import NavigationKit

struct ServerErrorView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        
        VStack{
            Image("ServerErrorImage")
                .resizable()
                .scaledToFit()
                .frame(width: 223, height: 223)
                .cornerRadius(70)
               
            Text("Ошибка сервера")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 16)
        }
    }
}

#Preview {
    ServerErrorView()
        .environmentObject(NavigationManager())
}
