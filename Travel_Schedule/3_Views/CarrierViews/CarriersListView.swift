//
//  CarriersListView.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import SwiftUI
import NavigationKit

struct CarrierListView: View {
    @ObservedObject var viewModel = CarrierViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var routeViewModel: RouteViewModel
    @AppStorage("isDarkMode") private var isDarkModeEnabled: Bool = false
    
    var body: some View {
        ZStack {
            (isDarkModeEnabled ? Color.black : Color.white).ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack {
                    Text("\(routeViewModel.fromText) \(Image(systemName: "arrow.right")) \(routeViewModel.toText)")
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                        .foregroundColor(isDarkModeEnabled ? .white : .black)
                        .background(Color.clear)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Загрузка рейсов...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                } else if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    VStack {
                        Text(errorMessage)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    Spacer()
                } else if viewModel.carriers.isEmpty {
                    Spacer()
                    Text("Рейсы не найдены")
                        .font(.headline)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.carriers) { carrier in
                            CarrierView(carrier: carrier)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    navigationManager.path.append(AppScreen.carrierInfo(carrier: carrier))
                                }
                                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                        
                        Color.clear
                            .frame(height: 130)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .background(isDarkModeEnabled ? Color.black : Color.white)
                    .listStyle(PlainListStyle())
                }
            }
            
            VStack {
                Spacer()
                Button(action: {
                    navigationManager.path.append(AppScreen.filters)
                }) {
                    Text("Уточнить время")
                        .frame(width: 343, height: 60)
                        .fontWeight(.bold)
                        .font(.system(size: 17))
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                .padding(.bottom, 58)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    navigationManager.path.removeLast()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(isDarkModeEnabled ? .white : .black)
                }
            }
        }
        .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        .onAppear {
            loadCarrierData()
        }
    }
    
    private func loadCarrierData() {
        if !routeViewModel.fromStationCode.isEmpty && !routeViewModel.toStationCode.isEmpty {
            viewModel.fetchData(
                from: routeViewModel.fromStationCode,
                to: routeViewModel.toStationCode,
                date: Config.SearchSettings.defaultDate
            )
        }
    }
}

struct CarrierListView_Previews: PreviewProvider {
    static var previews: some View {
        CarrierListView()
            .environmentObject(NavigationManager())
            .environmentObject(RouteViewModel())
    }
}
