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
    
    var body: some View {
        ZStack {
            
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack {
                    Text("\(routeViewModel.fromCity) (\(routeViewModel.fromStation)) \(Image(systemName: "arrow.right")) \(routeViewModel.toCity) (\(routeViewModel.toStation))")
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                        .background(Color.clear)
                }
                
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                List(viewModel.carriers) { carrier in
                    VStack {
                        CarrierView(carrier: carrier)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                navigationManager.path.append(AppScreen.carrierInfo(carrier: carrier))
                            }
                        Spacer().frame(height: 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
                .background(Color.white)
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
                        .foregroundColor(.black)
                }
            }
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
