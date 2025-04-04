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
       @StateObject private var errorManager = ErrorManager.shared
       
       var body: some View {
           VStack(spacing: 20) {
               Image("ServerErrorImage")
                   .resizable()
                   .scaledToFit()
                   .frame(width: 223, height: 223)
                   .cornerRadius(70)
                  
               Text("Ошибка сервера")
                   .font(.system(size: 24, weight: .bold))
                   .padding(.top, 16)
               
               Button(action: {
                             errorManager.hideServerError()
                         }) {
                             Text("Повторить")
                                 .font(.system(size: 16, weight: .semibold))
                                 .foregroundColor(.white)
                                 .padding(.vertical, 12)
                                 .padding(.horizontal, 30)
                                 .background(Color.blue)
                                 .cornerRadius(10)
                         }
               .padding(.top, 10)
           }
           .frame(maxWidth: .infinity, maxHeight: .infinity)
           .background(Color(UIColor.systemBackground).opacity(0.95))
           .edgesIgnoringSafeArea(.all)
       }
   }

#Preview {
    ServerErrorView()
        .environmentObject(NavigationManager())
}
