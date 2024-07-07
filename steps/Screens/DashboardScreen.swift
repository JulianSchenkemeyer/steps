//
//  ContentView.swift
//  steps
//
//  Created by Julian Schenkemeyer on 16.06.24.
//

import SwiftUI
import Charts

struct DashboardScreen: View {
//    @AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming = false
    @Environment(HealthKitManager.self) private var hkManager
    
    @State private var isShowingPermissionPrimingSheet = false
    @State private var steps: [HealthMetric] = []
    
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
                    
                }
            }
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
