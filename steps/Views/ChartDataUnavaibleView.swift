//
//  ChartDataUnavaibleView.swift
//  steps
//
//  Created by Julian Schenkemeyer on 14.07.24.
//

import SwiftUI

struct ChartDataUnavaibleView: View {
    let systemImage: String
    let title: String
    let description: String
    
    var body: some View {
        ContentUnavailableView {
            Image (systemName: systemImage)
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.bottom, 8)
            
            Text(title)
                .font(.callout.bold())
            
            Text(description)
                .font(.footnote)
        }
        .foregroundColor(.secondary)
    }
}

#Preview {
    ChartDataUnavaibleView(systemImage: "chart.line.uptrend.xyaxis", title: "No Data", description: "There is no data")
}
