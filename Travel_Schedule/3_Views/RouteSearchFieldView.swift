//
//  RouteSearchFieldView.swift
//  Travel_Schedule
//
//  Created by Kaider on 23.02.2025.
//

import SwiftUI
import NavigationKit

struct RouteSearchFieldView: View {
    
    @EnvironmentObject var routeViewModel: RouteViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    @State private var isReverseButtonAnimating = false
    
    private let serviceManager = ServiceManager.shared
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.blue)
                    .frame(width: 343, height: 128)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.white)
                    .frame(width: 259, height: 96)
                    .padding(.leading, 16)
                
                HStack {
                    VStack(spacing: 0) {
                        Text(routeViewModel.getFormattedFromText())
                            .foregroundColor(routeViewModel.fromCity.isEmpty ? .gray : .black)
                            .frame(width: 227, alignment: .leading)
                            .frame(height: 48)
                            .font(.system(size: 17))
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                routeViewModel.isSelectingFromCity = true
                                navigationManager.path.append(AppScreen.choosingCity(isSelectingFromCity: true))
                            }
                            .padding(.leading, 16)
                            .padding(.top, 14)
                        
                        Text(routeViewModel.getFormattedToText())
                            .foregroundColor(routeViewModel.toCity.isEmpty ? .gray : .black)
                            .frame(width: 227, alignment: .leading)
                            .frame(height: 48)
                            .font(.system(size: 17))
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                routeViewModel.isSelectingFromCity = false
                                navigationManager.path.append(AppScreen.choosingCity(isSelectingFromCity: false))
                            }
                            .padding(.leading, 16)
                            .padding(.bottom, 14)
                    }
                    .frame(width: 259, height: 96)
                    .padding(.leading, 16)
                }
                
                ZStack {
                    Circle()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(Color.white)
                    
                    Image(systemName: "arrow.2.squarepath")
                        .foregroundStyle(.blue)
                        .rotationEffect(isReverseButtonAnimating ? .degrees(180) : .degrees(0))
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.3)) {
                                isReverseButtonAnimating = true
                            }
                            
                            routeViewModel.swapCities()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.spring(duration: 0.3)) {
                                    isReverseButtonAnimating = false
                                }
                            }
                        }
                }
                .padding(.leading, 291)
            }
        }
    }
}
