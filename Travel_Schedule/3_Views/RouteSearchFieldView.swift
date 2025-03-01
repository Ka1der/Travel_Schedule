//
//  RouteSearchFieldView.swift
//  Travel_Schedule
//
//  Created by Kaider on 23.02.2025.
//

import SwiftUI

struct RouteSearchFieldView: View {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var routeModel: RouteModel
    
    private func formattedFromText() -> String {
           if routeModel.fromCity.isEmpty {
               return "Откуда"
           } else if routeModel.fromStations.isEmpty {
               return routeModel.fromCity
           } else {
               return "\(routeModel.fromCity) (\(routeModel.fromStations))"
           }
       }
       
       private func formattedToText() -> String {
           if routeModel.toCity.isEmpty {
               return "Куда"
           } else if routeModel.toStations.isEmpty {
               return routeModel.toCity
           } else {
               return "\(routeModel.toCity) (\(routeModel.toStations))"
           }
       }
    
    var body: some View {
        
        HStack{
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
                        Text(formattedFromText())
                            .foregroundColor(routeModel.fromCity.isEmpty ? .gray : .black)
                            .frame(width: 227, alignment: .leading)
                            .frame(height: 48)
                            .font(.system(size: 17))
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                routeModel.isSelectingFromCity = true
                                router.navigate(to: .choosingCity)
                            }
                            .padding(.leading, 16)
                            .padding(.top, 14)
                        
                        Text(formattedToText())
                            .foregroundColor(routeModel.toCity.isEmpty ? .gray : .black)
                            .frame(width: 227, alignment: .leading)
                            .frame(height: 48)
                            .font(.system(size: 17))
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                routeModel.isSelectingFromCity = false
                                router.navigate(to: .choosingCity)
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
                        .onTapGesture {
                            let tempFromCity = routeModel.fromCity
                            let tempFromStations = routeModel.fromStations
                            routeModel.fromCity = routeModel.toCity
                            routeModel.fromStations = routeModel.toStations
                            routeModel.toCity = tempFromCity
                            routeModel.toStations = tempFromStations
                        }
                }
                .padding(.leading, 291)
            }
        }
    }
}


#Preview {
    RouteSearchFieldView()
        .environmentObject(Router())
        .environmentObject(RouteModel())
}
