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
        ChartContainerBase {
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
        } content: {
            content()
        }
        
    }
}

struct ChartContainerWithNavigation<Content: View>: View {
    let title: String
    let systemImage: String
    let subtitle: String
    let context: String
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ChartContainerBase {
            NavigationLink(value: context) {
                HStack {
                    VStack(alignment: .leading) {
                        Label(title, systemImage: systemImage)
                            .font(.title3.bold())
                            .foregroundStyle(.cyan)
                        
                        Text(subtitle)
                            .font(.caption)
                    }
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.secondary)
        } content: {
            content()
        }
        
    }
}

struct ChartContainerBase<Header: View, Content: View>: View {
    @ViewBuilder var header: () -> Header
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header()
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
    VStack {
        ChartContainer(title: "Chart Container",
                       systemImage: "calendar",
                       subtitle: "subtitle") {
            Text("Chart")
                .frame(height: 180)
        }
        
        ChartContainerWithNavigation(title: "Chart Container with Navigation",
                                     systemImage: "calendar",
                                     subtitle: "subtitle",
                                     context: "test") {
            Text("Chart")
                .frame(height: 180)
        }
    }
}
