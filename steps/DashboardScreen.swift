//
//  ContentView.swift
//  steps
//
//  Created by Julian Schenkemeyer on 16.06.24.
//

import SwiftUI

struct DashboardScreen: View {
    @AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming = false
    @Environment(HealthKitManager.self) private var hkManager
    
    @State private var isShowingPermissionPrimingSheet = false
    
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
                                    Text("Avg: 10K Steps")
                                        .font(.caption)
                                }
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                        }
                        .foregroundStyle(.secondary)
                    }
                    
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.secondary)
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
                await hkManager.fetchStepsData()
//                #if targetEnvironment(simulator)
//                await hkManager.addMockData()
//                #endif
            }
            .fullScreenCover(isPresented: $isShowingPermissionPrimingSheet) {
                HealthPermissionPrimingSheet()
            }
        }
    }
}

#Preview {
    DashboardScreen()
        .environment(HealthKitManager())
}
