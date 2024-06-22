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
    
    var averageSteps: Double {
        guard !steps.isEmpty else { return 0 }
        let totalSteps = steps.reduce(0.0) { $0 + $1.value }
        return totalSteps / Double(steps.count)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack {
                        NavigationLink(value: "Steps") {
                            HStack {
                                VStack(alignment: .leading) {
                                    Label("Steps", systemImage: "figure.walk")
                                        .font(.title3.bold())
                                        .foregroundStyle(.cyan)
                                    Text("Avg: \(Int(averageSteps), format: .number.notation(.compactName)) Steps")
                                        .font(.caption)
                                }
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                        }
                        .foregroundStyle(.secondary)
                    }
                    
                    Chart(steps) { step in
                        RuleMark(y: .value("Average", averageSteps))
                            .foregroundStyle(Color.secondary)
                            .lineStyle(.init(lineWidth: 1, dash: [7]))
                        
                        BarMark(
                            x: .value("Date",
                                      step.date,
                                      unit: .day),
                            y: .value("Count", step.value)
                        )
                        .foregroundStyle(Color.cyan.gradient)
                    }
                    .chartXAxis {
                        AxisMarks {
                            AxisValueLabel(format: .dateTime.day().month(.defaultDigits))
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisGridLine()
                                .foregroundStyle(Color.secondary.opacity(0.2))
                            AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
                        }
                    }
                    .frame(height: 150)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                }
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
