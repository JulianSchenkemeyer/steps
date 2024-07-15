//
//  ChartContainer.swift
//  steps
//
//  Created by Julian Schenkemeyer on 14.07.24.
//

import SwiftUI

struct ChartContainer<Content: View>: View {
    let title: String
    let systemImage: String
    let subtitle: String
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Label(title, systemImage: systemImage)
                        .font(.title3.bold())
                        .foregroundStyle(.cyan)
                    
                    Text(subtitle)
                        .font(.caption)
                }
                Spacer()
            }
            .foregroundStyle(.secondary)
            
            
            content()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Material.thin)
        }
    }
}

#Preview {
    ChartContainer(title: "Chart Container", systemImage: "calendar", subtitle: "subtitle") {
        Text("Chart")
            .frame(height: 180)
    }
}
