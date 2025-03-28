//
//  CarrierViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import Foundation

class CarrierViewModel: ObservableObject {
    @Published var carriers: [CarrierModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var allowTransfers: Bool = true
    
    func updateCarriers(from searchResults: Components.Schemas.Search) {
        if searchResults.segments == nil || searchResults.segments!.isEmpty {
            DispatchQueue.main.async {
                self.carriers = []
                self.isLoading = false
                self.errorMessage = nil
            }
            return
        }
        
        guard let segments = searchResults.segments, !segments.isEmpty else { return }
        
        var allCarriers: [CarrierModel] = []
        
        for segment in segments {
            if let carrier = segment.thread?.carrier,
               let codeValue = carrier.code,
               let title = carrier.title,
               let number = segment.thread?.number {
                
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
                    if let transferPoints = segment.transfer_points, !transferPoints.isEmpty {
                        hasTransfer = true
                    } else if let transferCount = segment.transfers as? Int {
                        hasTransfer = transferCount > 0
                    } else if let transferArray = segment.transfers as? [Any], !transferArray.isEmpty {
                        hasTransfer = true
                    }
                    
                    var transferLocation: String? = nil
                    if hasTransfer, let transferPoints = segment.transfer_points, !transferPoints.isEmpty {
                        let transferStations = transferPoints.compactMap { $0.station?.title }
                        transferLocation = transferStations.joined(separator: ", ")
                    }
                    
                    //     let enrichedName = "\(title) (№\(number))" c номером рейса
                    let enrichedName = title
                    
                    let carrierModel = CarrierModel(
                        name: enrichedName,
                        logo: logoUrl,
                        code: codeInt,
                        departureTime: departureTimeStr,
                        arrivalTime: arrivalTimeStr,
                        duration: durationMinutes,
                        tripDate: tripDateStr,
                        hasTransfer: hasTransfer,
                        transferLocation: transferLocation
                    )
                    
                    allCarriers.append(carrierModel)
                }
            }
        }
        DispatchQueue.main.async {
            self.carriers = allCarriers
            self.isLoading = false
            self.errorMessage = nil
        }
    }
    
    func fetchData(from: String, to: String, date: String, allowTransfers: Bool = true) {
        isLoading = true
        errorMessage = nil
        self.allowTransfers = allowTransfers
        
        ServiceManager.shared.requestSearch(
            from: from,
            to: to,
            date: date,
            transfers: allowTransfers,
            carrierViewModel: self
        )
    }
}
