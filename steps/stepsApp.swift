//
//  stepsApp.swift
//  steps
//
//  Created by Julian Schenkemeyer on 16.06.24.
//

import SwiftUI

@main
struct stepsApp: App {
    
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardScreen()
                .environment(hkManager)
        }
    }
}
