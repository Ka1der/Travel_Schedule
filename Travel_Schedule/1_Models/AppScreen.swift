//
//  AppScreen.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import SwiftUI
import NavigationKit

enum AppScreen: Screen, Hashable {
    case main
    case choosingCity(isSelectingFromCity: Bool)
    case choosingStation(isSelectingFromCity: Bool)
    case userAgreementView
    case carrierList
    case carrierInfo(carrier: CarrierModel)
    case filters
    case storiesLargeView(index: Int)
    
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
            ChoosingStationsView(
                viewModel: StationSelectionViewModel(
                    city: isSelectingFromCity ? "Город отправления" : "Город прибытия"
                ),
                isSelectingFromCity: isSelectingFromCity
            )
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
