//
//  CarrierViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation
import Combine

class CarrierViewModel: ObservableObject {
    @Published var carriers: [CarrierModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var allowTransfers: Bool = true
    
    private var allCarriers: [CarrierModel] = []
    private let filterService = FilterService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        filterService.$currentFilters
            .sink { [weak self] newFilters in
                self?.applyFilters(with: newFilters)
            }
            .store(in: &cancellables)
    }
    
    func fetchData(from: String, to: String, date: String, allowTransfers: Bool = true) {
        isLoading = true
        errorMessage = nil
        self.allowTransfers = allowTransfers
        
        Task {
            await ServiceManager.shared.requestSearch(
                from: from,
                to: to,
                date: date,
                transfers: allowTransfers,
                carrierViewModel: self
            )
        }
    }
    
    func updateCarriers(from searchResults: Components.Schemas.Search) {
        if searchResults.segments == nil || searchResults.segments!.isEmpty {
            DispatchQueue.main.async {
                self.carriers = []
                self.allCarriers = []
                self.isLoading = false
                self.errorMessage = nil
            }
            return
        }
        
        guard let segments = searchResults.segments, !segments.isEmpty else { return }
        
        var newCarriers: [CarrierModel] = []
        
        for segment in segments {
            if let carrier = segment.thread?.carrier,
               let codeValue = carrier.code,
               let title = carrier.title,
               let number = segment.thread?.number {
                
                var codeString = String(describing: codeValue).trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
                
                if codeString.isEmpty {
                    codeString = "0"
                    print("Empty code after cleaning, using default")
                }
                
                let codeInt = Int(String(describing: codeValue)) ?? 0
                if codeInt > 0 {
                    var logoUrl = "NoLogo"
                    
                    if let svgLogo = carrier.logo_svg, !svgLogo.isEmpty {
                        logoUrl = svgLogo
                    } else if let logo = carrier.logo, !logo.isEmpty {
                        logoUrl = logo
                    }
                    
                    var departureTimeStr: String? = nil
                    var arrivalTimeStr: String? = nil
                    var tripDateStr: String? = nil
                    
                    var durationMinutes: Int? = nil
                    if let duration = segment.duration {
                        durationMinutes = duration / 60
                    }
                    
                    if let departureDate = segment.departure {
                        departureTimeStr = TimeFormatter.formatTimeFromDate(departureDate)
                        tripDateStr = TimeFormatter.formatDateToRussian(departureDate)
                    }
                    
                    if let arrivalDate = segment.arrival {
                        arrivalTimeStr = TimeFormatter.formatTimeFromDate(arrivalDate)
                    }
                    
                    var hasTransfer = false
                    var transferLocation: String? = nil
                    
                    if let transferPoints = segment.transfer_points, !transferPoints.isEmpty {
                        hasTransfer = true
                        let transferStations = transferPoints.compactMap { $0.station?.title }
                        transferLocation = transferStations.joined(separator: ", ")
                    }
                    
                    let carrierModel = CarrierModel(
                        name: title,
                        logo: logoUrl,
                        code: Int(codeString),
                        codeString: codeString,
                        departureTime: departureTimeStr,
                        arrivalTime: arrivalTimeStr,
                        duration: durationMinutes,
                        tripDate: tripDateStr,
                        hasTransfer: hasTransfer,
                        transferLocation: transferLocation
                    )
                    
                    newCarriers.append(carrierModel)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.allCarriers = newCarriers
            self.isLoading = false
            self.errorMessage = nil
            self.applyFilters(with: self.filterService.currentFilters)
        }
    }
    
    private func applyFilters(with settings: FilterSettings) {
        guard !allCarriers.isEmpty else {
            carriers = []
            return
        }
        
        let filteredResult = allCarriers.filter { carrier in
            let passesTimeFilter = settings.isTimeInSelectedPeriods(carrier.departureTime)
            let passesTransferFilter = settings.showTransfers ? true : !carrier.hasTransfer
            
            return passesTimeFilter && passesTransferFilter
        }
        
        DispatchQueue.main.async {
            self.carriers = filteredResult
        }
    }
}
