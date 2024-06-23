//
//  ContentView.swift
//  steps
//
//  Created by Julian Schenkemeyer on 16.06.24.
//

import SwiftUI
import Charts

struct DashboardScreen: View {
    @AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming = false
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
                Text(metric)
            }
            .task {
                isShowingPermissionPrimingSheet = !hasSeenPermissionPriming
                
                //TODO: abort if user has no permission
                steps = await hkManager.fetchStepsData()
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
