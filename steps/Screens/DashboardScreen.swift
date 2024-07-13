//
//  ContentView.swift
//  steps
//
//  Created by Julian Schenkemeyer on 16.06.24.
//

import SwiftUI
import Charts

struct DashboardScreen: View {
    @Environment(HealthKitManager.self) private var hkManager
    
    @State private var isShowingPermissionPrimingSheet = false
    @State private var steps: [HealthMetric] = []
    @State private var isShowingError = false
    @State private var healthManagerError: HealthManagerError = .unableToCompleteRequest
    
    var averageStepsPerWeekday: [HealthMetric] { ChartMath.averageWeekdayCount(for: steps) }

    
    var body: some View {
        NavigationStack {
            ScrollView {
                StepChart(steps: steps)
                AverageStepsPerWeekdayView(chartData: averageStepsPerWeekday)
            }
            .padding()
            .navigationTitle("Dashboard")
            .navigationDestination(for: String.self) { metric in
                HealthDataOverviewScreen(healthMetric: "Steps")
            }
            .task {
                do {
                    steps = try await hkManager.fetchStepsData()
                } catch HealthManagerError.authorizationNotDetermined {
                    isShowingPermissionPrimingSheet = true
                } catch {
                    healthManagerError = .unableToCompleteRequest
                    isShowingError = true
                }
            }
            .alert(isPresented: $isShowingError, error: healthManagerError, actions: {_ in 
                
            }, message: { healthManagerError in
                Text(healthManagerError.failureReason)
            })
            .fullScreenCover(isPresented: $isShowingPermissionPrimingSheet) {
                HealthPermissionPrimingSheet()
            }
        }
        .tint(.cyan)
    }
}

#Preview {
    DashboardScreen()
        .environment(HealthKitManager())
}
