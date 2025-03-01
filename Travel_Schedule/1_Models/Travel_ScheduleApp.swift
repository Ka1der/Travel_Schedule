//
//  Travel_ScheduleApp.swift
//  Travel_Schedule
//
//  Created by Kaider on 06.02.2025.
//

import SwiftUI

@main
struct Travel_ScheduleApp: App {
    
    @StateObject private var router = Router()
    @StateObject private var routeModel = RouteModel()
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(router)
                .environmentObject(routeModel)
        }
    }
}
