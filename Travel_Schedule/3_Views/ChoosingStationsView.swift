//
//  ChoosingStationsView.swift
//  Travel_Schedule
//
//  Created by Kaider on 26.02.2025.
//

import SwiftUI

struct ChoosingStationsView: View {
    
    @State private var searchText = ""
    @EnvironmentObject var router: Router
    @EnvironmentObject var routeModel: RouteModel
    
    var filteredStation: [String] {
        if searchText.isEmpty {
            return stations
        }
        return stations.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        VStack{
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
            
            if filteredStation.isEmpty {
                Text("Станция не найдена")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            List(filteredStation, id: \.self) { station in
                HStack {
                    Text(station)
                        .font(.system(size: 17))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                }
                .padding(.vertical, 8)
                .contentShape(Rectangle())
                .onTapGesture {
                    if routeModel.isSelectingFromCity {
                                  routeModel.fromStations = station
                              } else {
                                  routeModel.toStations = station
                              }
                    router.navigateToRoot()
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Выбор станции")
    }
}

#Preview {
    ChoosingStationsView()
        .environmentObject(Router())
        .environmentObject(RouteModel())
}
