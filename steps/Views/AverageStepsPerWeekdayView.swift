//
//  AverageStepsPerWeekdayView.swift
//  steps
//
//  Created by Julian Schenkemeyer on 22.06.24.
//

import SwiftUI
import Charts


struct AverageStepsPerWeekdayView: View {
    var chartData: [HealthMetric]
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                VStack {
                    NavigationLink(value: "Steps") {
                        HStack {
                            VStack(alignment: .leading) {
                                Label("Averages", systemImage: "calendar")
                                    .font(.title3.bold())
                                    .foregroundStyle(.cyan)
                                
                                Text("Last 28 Days")
                                    .font(.caption)
                            }
                            Spacer()
                        }
                    }
                    .foregroundStyle(.secondary)
                }
                
                Chart {
                    ForEach(chartData) { weekday in
                        SectorMark(angle: .value("Average Steps", weekday.value),
                                   innerRadius: .ratio(0.65),
                                   angularInset: 1)
                        .cornerRadius(5)
                    }
                }
            }
        }
        .frame(height: 300)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Material.thin)
        }
    }
}

#Preview {
    AverageStepsPerWeekdayView(chartData: ChartMath.averageWeekdayCount(for: HealthMockData.getSteps()))
}
