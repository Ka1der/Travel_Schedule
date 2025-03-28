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
                routeHeaderView
                contentView
            }
            VStack {
                Spacer()
                filterButton
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        .onAppear {
            loadCarrierData()
        }
    }
    
    private var routeHeaderView: some View {
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
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            loadingView
        } else if let _ = viewModel.errorMessage, viewModel.carriers.isEmpty {
            emptyStateView
        } else if viewModel.carriers.isEmpty {
            emptyStateView
        } else {
            carrierListView
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView("Загрузка рейсов...")
                .progressViewStyle(CircularProgressViewStyle())
            Spacer()
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("Вариантов нет")
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
    
    private var carrierListView: some View {
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
    
    private var filterButton: some View {
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
    
    private var backButton: some View {
        Button(action: {
            navigationManager.path.removeLast()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(isDarkModeEnabled ? .white : .black)
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
