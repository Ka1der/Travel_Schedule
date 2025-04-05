//
//  CarrierModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 02.03.2025.
//

import SwiftUI

struct CarrierModel: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let logoSource: LogoSource
    let code: Int?
    let codeString: String?
    let departureTime: String?
    let arrivalTime: String?
    let duration: Int?
    let tripDate: String?
    let hasTransfer: Bool
    let transferLocation: String?
    
    enum LogoSource: Hashable {
        case local(name: String)
        case remote(url: URL)
    }
    
    init(name: String,
         logo: String,
         code: Int? = nil,
         codeString: String? = nil,
         departureTime: String? = nil,
         arrivalTime: String? = nil,
         duration: Int? = nil,
         tripDate: String? = nil,
         hasTransfer: Bool = false,
         transferLocation: String? = nil) {
        
        self.name = name
        self.code = code
        self.codeString = codeString ?? code.map { String($0) }
        self.departureTime = departureTime
        self.arrivalTime = arrivalTime
        self.duration = duration
        self.tripDate = tripDate
        self.hasTransfer = hasTransfer
        self.transferLocation = transferLocation
        
        if let url = URL(string: logo), logo.hasPrefix("http") || logo.hasPrefix("//") {
            self.logoSource = .remote(url: url)
        } else {
            self.logoSource = .local(name: logo)
        }
    }
    
    static func == (lhs: CarrierModel, rhs: CarrierModel) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
