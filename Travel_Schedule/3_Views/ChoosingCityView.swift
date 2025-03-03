//
//  ChoosingCityView.swift
//  Travel_Schedule
//
//  Created by Kaider on 23.02.2025.
//

import SwiftUI
import NavigationKit

struct ChoosingCityView: View {
    @ObservedObject var viewModel: CitySelectionViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var routeViewModel: RouteViewModel
    
    var isSelectingFromCity: Bool
    
    init(viewModel: CitySelectionViewModel, isSelectingFromCity: Bool) {
        self.viewModel = viewModel
        self.isSelectingFromCity = isSelectingFromCity
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Введите запрос", text: $viewModel.searchText)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
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
            
            if viewModel.filteredCities.isEmpty {
                Text("Город не найден")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            List(viewModel.filteredCities, id: \.self) { city in
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
                    routeViewModel.selectCity(city: city, isFromCity: isSelectingFromCity)
                    navigationManager.path.append(AppScreen.choosingStation(isSelectingFromCity: isSelectingFromCity))
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Выбор города")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigationManager.path.removeLast()
                }) {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}
