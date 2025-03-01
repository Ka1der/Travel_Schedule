//
//  ChoosingCityView.swift
//  Travel_Schedule
//
//  Created by Kaider on 23.02.2025.
//

import SwiftUI

struct ChoosingCityView: View {
    
    @State private var searchText = ""
    @EnvironmentObject var router: Router
    @EnvironmentObject var routeModel: RouteModel
    
    var filteredCities: [String] {
        if searchText.isEmpty {
            return cities
        }
        return cities.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        VStack {
            HStack {
                         Image(systemName: "magnifyingglass")
                             .foregroundColor(.gray)
                         TextField("Введите запрос", text: $searchText)
                           
                         if !searchText.isEmpty {
                             Button(action: {
                                 searchText = ""
                             }) {
                                 Image(systemName: "xmark.circle.fill")
                                     .foregroundColor(.gray)
                             }
                         }
                     }
                     .padding(.horizontal)
                     .padding(.vertical, 10)
                     .background(Color(.systemGray6))
                     .cornerRadius(10)
                     .padding()
            
            if filteredCities.isEmpty {
                Text("Город не найден")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            List(filteredCities, id: \.self) { city in
                HStack {
                    Text(city)
                        .font(.system(size: 17))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                }
                .padding(.vertical, 8)
                .contentShape(Rectangle())
                .onTapGesture {
                    if routeModel.isSelectingFromCity {
                        routeModel.fromCity = city
                    } else {
                        routeModel.toCity = city
                    }
                    router.navigate(to: .choosingStation)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            
        }
        .navigationTitle("Выбор города")
    }
}

#Preview {
    ChoosingCityView()
        .environmentObject(Router())
        .environmentObject(RouteModel())
}
