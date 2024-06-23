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
    
    @State private var selectedData: Double? = 0
    
    var selectedWeekday: HealthMetric? {
        guard let selectedData else { return nil }
        var total = 0.0
        
        return chartData.first {
            total += $0.value
            return selectedData <= total
        }
    }
    
    func isSelected(_ weekday: HealthMetric) -> Bool {
        selectedWeekday == nil || selectedWeekday?.date == weekday.date
    }
    
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
                                   outerRadius:  isSelected(weekday) ? 130 : 110,
                                   angularInset: 1)
                        .cornerRadius(5)
                        .foregroundStyle(Color.cyan.gradient)
                        .opacity(isSelected(weekday) ? 1 : 0.2)
                    }
                }
                .chartAngleSelection(value: $selectedData.animation(.easeInOut))
                .chartBackground { proxy in
                    GeometryReader { geometry in
                        if let plotFrame = proxy.plotFrame, let selectedWeekday {
                            let frame = geometry[plotFrame]
                            VStack {
                                Text(selectedWeekday.date.weekdayTitle)
                                    .font(.title3.bold())
                                    .contentTransition(.identity)
                                
                                Text(selectedWeekday.value, format: .number.precision(.fractionLength(0)))
                                    .contentTransition(.numericText())
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                            }
                            .position(x: frame.midX, y: frame.midY)
                        }
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
    
    //    var annotation: some View {
    //        guard let selectedWeekday else { return EmptyView() }
    //            return VStack {
    //
    //            }
    //    }
}

#Preview {
    AverageStepsPerWeekdayView(chartData: ChartMath.averageWeekdayCount(for: HealthMockData.getSteps()))
}
