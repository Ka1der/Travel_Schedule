//
//  AppScreen.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import SwiftUI
import NavigationKit
import Combine

enum AppScreen: Screen, Hashable {
    case main
    case choosingCity(isSelectingFromCity: Bool)
    case choosingStation(isSelectingFromCity: Bool)
    case userAgreementView
    case carrierList
    case carrierInfo(carrier: CarrierModel)
    case filters
    case storiesLargeView(index: Int)
    
    @ViewBuilder
    var body: some View {
        switch self {
        case .main:
            MainView()
        case .choosingCity(let isSelectingFromCity):
            ChoosingCityView(
                viewModel: CitySelectionViewModel(),
                isSelectingFromCity: isSelectingFromCity
            )
        case .choosingStation(let isSelectingFromCity):
            CityStateContainer(isSelectingFromCity: isSelectingFromCity) { selectedCity in
                ChoosingStationsView(
                    viewModel: StationSelectionViewModel(city: selectedCity),
                    isSelectingFromCity: isSelectingFromCity
                )
            }
        case .userAgreementView:
            UserAgreementView()
        case .carrierList:
            CarrierListView()
        case .carrierInfo(let carrier):
            CarrierInfoView(carrier: carrier)
        case .filters:
            FiltersView()
        case .storiesLargeView(let index):
            StoriesLargeView(story: stories[index], initialIndex: index)
        }
    }
}

private struct CityStateContainer<Content: View>: View {
    @EnvironmentObject var routeViewModel: RouteViewModel
    let isSelectingFromCity: Bool
    let content: (String) -> Content
    
    var body: some View {
        let selectedCity = isSelectingFromCity ?
            routeViewModel.fromPoint.city ?? "Выберите город" :
            routeViewModel.toPoint.city ?? "Выберите город"
        
        content(selectedCity)
    }
}
