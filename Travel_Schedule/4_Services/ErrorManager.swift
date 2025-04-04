//
//  ErrorManager.swift
//  Travel_Schedule
//
//  Created by Kaider on 04.04.2025.
//

import Foundation
import Combine

class ErrorManager: ObservableObject {
    static let shared = ErrorManager()
    
    @Published var hasServerError = false
    
    let serverErrorPublisher = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        serverErrorPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] hasError in
                self?.hasServerError = hasError
            }
            .store(in: &cancellables)
    }
    
    func showServerError() {
        serverErrorPublisher.send(true)
    }
    
    func hideServerError() {
        serverErrorPublisher.send(false)
    }
}
