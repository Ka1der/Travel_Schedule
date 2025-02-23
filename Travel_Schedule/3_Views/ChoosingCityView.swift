//
//  ChoosingCityView.swift
//  Travel_Schedule
//
//  Created by Kaider on 23.02.2025.
//

import SwiftUI

struct ChoosingCityView: View {
    
    @State private var searchText = ""
    
    var filteredCities: [String] {
        if searchText.isEmpty {
            return cities
        }
        return cities.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        
        NavigationView {
            VStack{
                List(filteredCities, id: \.self) {city in
                    NavigationLink(destination: Text("Детали для \(city)")) {
                        Text(city)
                            .font(.system(size: 17))
                            .padding(.vertical, 8)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Поиск города")
            .navigationTitle("Выбор города")
        }
    }
}

#Preview {
    ChoosingCityView()
}
