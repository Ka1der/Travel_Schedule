//
//  CarrierInfoViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.04.2025.
//

import Foundation
import Combine

class CarrierInfoViewModel: ObservableObject {
    @Published var carrier: Components.Schemas.Carrier?
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var carrierName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var website: String = ""
    @Published var logoUrl: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadCarrierInfo(code: Int) {
        loadCarrierInfo(codeString: String(code))
    }

    func loadCarrierInfo(codeString: String) {
        guard !codeString.isEmpty else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
               
                let carrierInfo = try await ServiceManager.shared.requestCarrierInfo(code: codeString)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.carrier = carrierInfo
                    self.carrierName = carrierInfo.title ?? ""
                    self.email = carrierInfo.email ?? ""
                    self.phone = carrierInfo.phone ?? ""
                    self.website = carrierInfo.url ?? ""
                    self.logoUrl = carrierInfo.logo ?? ""

                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
