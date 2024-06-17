//
//  HealthPermissionPrimingSheet.swift
//  steps
//
//  Created by Julian Schenkemeyer on 17.06.24.
//

import SwiftUI
import HealthKitUI

struct HealthPermissionPrimingSheet: View {
    @Environment(HealthKitManager.self) private var hkManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingHealthKitPermissions = false
    
    
    let description = """
This app displays your step data in interactive charts.

You can also add new step data to Apple Health from this app. Your data is private and secured.
"""
    
    var body: some View {
        VStack(spacing: 90) {
            VStack(alignment: .leading, spacing: 30) {
                Image(.appleHealthLogo)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .shadow(color: .gray.opacity(0.4),radius: 5)
                
                Text("Apple Health Integration")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            Button {
                isShowingHealthKitPermissions = true
            } label: {
                Text("Connect to Apple Health")
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .padding(20)
        .healthDataAccessRequest(store: hkManager.store,
                                 shareTypes: hkManager.types,
                                 readTypes: hkManager.types,
                                 trigger: isShowingHealthKitPermissions) { result in
            switch result {
            case .success(let success):
                dismiss()
            case .failure(let failure):
                // Handle failure
                dismiss()
            }
        }
    }
}

#Preview {
    HealthPermissionPrimingSheet()
        .environment(HealthKitManager())
}
