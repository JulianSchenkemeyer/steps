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
    @State private var lastSelectedValue: Double = 0

    
    var selectedWeekday: HealthMetric? {
        var total = 0.0
        
        return chartData.first {
            total += $0.value
            return lastSelectedValue <= total
        }
    }
    
    func isSelected(_ weekday: HealthMetric) -> Bool {
        selectedWeekday == nil || selectedWeekday?.date == weekday.date
    }
    
    var body: some View {
        ChartContainer(title: "Averages", systemImage: "calendar", subtitle: "Last 28 Days") {
            
            if chartData.isEmpty {
                ChartDataUnavaibleView(systemImage: "chart.pie",
                                       title: "No Data",
                                       description: "There is no step count data from the Health App")
            } else {
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
                .chartAngleSelection(value: $selectedData)
                .onChange(of: selectedData) { old, new in
                    guard let new else {
                        lastSelectedValue = old ?? 0
                        return
                    }
                    lastSelectedValue = new
                }
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
                .sensoryFeedback(.selection, trigger: selectedWeekday) { oldValue, newValue in
                    guard let oldDate = oldValue?.date, let newDate = newValue?.date else { return false
                    }
                    return oldDate != newDate
                }
            }
        }
        .frame(height: 320)
    }
}

#Preview {
    AverageStepsPerWeekdayView(chartData: ChartMath.averageWeekdayCount(for: HealthMockData.getSteps()))
}
