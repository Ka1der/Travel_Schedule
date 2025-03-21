//
//  ChoosingStationsView.swift
//  Travel_Schedule
//
//  Created by Kaider on 26.02.2025.
//

import SwiftUI
import NavigationKit

struct ChoosingStationsView: View {
    @ObservedObject var viewModel: StationSelectionViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var routeViewModel: RouteViewModel
    @AppStorage("isDarkMode") private var isDarkModeEnabled: Bool = false
    
    var selectionState: RouteViewModel.SelectionState
    
    init(viewModel: StationSelectionViewModel, isSelectingFromCity: Bool) {
        self.viewModel = viewModel
        self.selectionState = isSelectingFromCity ? .from : .to
    }
    
    var body: some View {
        VStack{
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
            .background(isDarkModeEnabled ? Color(.systemGray5) : Color(.systemGray6))
            .cornerRadius(10)
            .padding()
            
            if viewModel.filteredStations.isEmpty {
                Text("Станция не найдена")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            List(viewModel.filteredStations, id: \.self) { station in
                          HStack {
                              Text(station)
                                  .font(.system(size: 17))
                              
                              Spacer()
                              
                              Image(systemName: "chevron.right")
                                  .foregroundColor(isDarkModeEnabled ? .white : .black)
                          }
                          .padding(.vertical, 8)
                          .contentShape(Rectangle())
                          .onTapGesture {
                              routeViewModel.selectStation(station, for: selectionState)
                              navigationManager.path.removeLast(navigationManager.path.count)
                          }
                          .listRowSeparator(.hidden)
                      }
                      .listStyle(PlainListStyle())
                  }
        .navigationTitle("Выбор станции")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigationManager.path.removeLast()
                }) {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(isDarkModeEnabled ? .white : .black)
                    }
                }
            }
        }
        .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
    }
}
