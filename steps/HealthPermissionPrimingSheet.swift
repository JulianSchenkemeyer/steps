//
//  HealthPermissionPrimingSheet.swift
//  steps
//
//  Created by Julian Schenkemeyer on 17.06.24.
//

import SwiftUI

struct HealthPermissionPrimingSheet: View {
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
                // Permission
            } label: {
                Text("Connect to Apple Health")
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .padding(20)
    }
}

#Preview {
    HealthPermissionPrimingSheet()
}
