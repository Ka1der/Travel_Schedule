//
//  MainView.swift
//  Travel_Schedule
//
//  Created by Kaider on 06.02.2025.
//

import SwiftUI

struct MainView: View {
    @State private var carrier = "Carrier wait test"
    @State private var copyright = "Copyright wait test"
    @State private var nearestSettlement = "Nearest Settlement wait test"
    @State private var nearestStations = "Neared Stations wait test"
    @State private var schedule = "Schedule wait test"
    @State private var search = "Search wait test"
    @State private var stationList = "Station List wait test"
    @State private var thread = "Thread wait test"
    
    private let apiService = TestAPIService()
    
    var body: some View {
        VStack {
            Button("Run API test") {
                runTests()
                
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(16)
            .padding()
            
            Divider()
            Spacer()
            
            Text("\(carrier)\n\(copyright)\n\(nearestSettlement)\n\(nearestStations)\n\(schedule)\n\(search)\n\(stationList)\n\(thread)")
                .frame(maxHeight: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    func runTests() {
        Task {
            await runTest(test: apiService.testNearestStations, result: $nearestStations, successText: "Nearest test started. See console")
            await runTest(test: apiService.testThread, result: $thread, successText: "Thread test started. See console")
            await runTest(test: apiService.testStationsList, result: $stationList, successText: "Station List test started. See console")
            await runTest(test: apiService.testSearch, result: $search, successText: "Search test started. See console")
            await runTest(test: apiService.testShedule, result: $schedule, successText: "Schedule test started. See console")
            await runTest(test: apiService.testNearestSettlement, result: $nearestSettlement, successText: "Nearest Settlement Ttest started. See console")
            await runTest(test: apiService.testCarrier, result: $carrier, successText: "Carrier test started. See console")
            await runTest(test: apiService.testCopyright, result: $copyright, successText: "Copyright test started. See console")
        }
    }
    
    func runTest(test: @escaping () async -> Void, result: Binding<String>, successText: String) async {
        await test()
        result.wrappedValue = successText
    }
  }

#Preview {
    MainView()
}
