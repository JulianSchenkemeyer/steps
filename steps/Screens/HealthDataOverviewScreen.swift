//
//  HealthDataListScreen.swift
//  steps
//
//  Created by Julian Schenkemeyer on 16.06.24.
//

import SwiftUI

struct HealthDataOverviewScreen: View {
    @Environment(HealthKitManager.self) private var hkManager
    @State private var isShowingAddData = false
    @State private var healthData: [HealthMetric] = []
    
    var healthMetric: String
    
    var body: some View {
        List(healthData.reversed()) { data in
            HStack {
                Text(data.date, format: .dateTime.month(.abbreviated)
                    .day(.twoDigits)
                    .year(.extended()))
                
                Spacer()
                
                Text(data.value, format: .number.precision(.fractionLength(0)))
            }
        }
        .navigationTitle(healthMetric)
        .task {
            healthData = await hkManager.fetchStepsData()
        }
        .sheet(isPresented: $isShowingAddData, onDismiss: {
            Task {
                healthData = await hkManager.fetchStepsData()
            }
        }) {
            AddNewHealthDataSheet()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingAddData = true
                } label: {
                    Label("Add Data", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataOverviewScreen(healthMetric: "Steps")
            .environment(HealthKitManager())
    }
}
