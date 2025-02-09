//
//  Copyright.swift
//  Travel_Schedule
//
//  Created by Kaider on 09.02.2025.
//

import Foundation

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Copyright = Components.Schemas.Copyright

protocol CopyrightServiceProtocol {
    func getCopyright(apikey: String)
    async throws -> Copyright
}

final class CopyrightService: CopyrightServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(
        client: Client,
        apikey: String) {
            self.client = client
            self.apikey = apikey
        }
    
    func getCopyright(apikey: String) async throws -> Copyright {
        let response = try await client.getCopyright(query: .init(
            apikey: apikey
        ))
        return try response.ok.body.json
    }
}
