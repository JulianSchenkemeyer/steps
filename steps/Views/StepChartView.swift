//
//  StepChart.swift
//  steps
//
//  Created by Julian Schenkemeyer on 22.06.24.
//

import SwiftUI
import Charts

struct StepChart: View {
    var steps: [HealthMetric] = []
    @State private var selectedDate: Date?
    
    var averageSteps: Double {
        guard !steps.isEmpty else { return 0 }
        let totalSteps = steps.reduce(0.0) { $0 + $1.value }
        
        return totalSteps / Double(steps.count)
    }
    
    var selectedHealthMetric: HealthMetric? {
        guard let selectedDate else { return nil }
        return steps.first { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    var body: some View {
        ChartContainerWithNavigation(title: "Steps",
                                     systemImage: "figure.walk",
                                     subtitle: "Avg: \(averageSteps.formatted(.number.notation(.compactName))) Steps",
                                     context: "steps") {
            
            if steps.isEmpty {
                ChartDataUnavaibleView(systemImage: "chart.bar",
                                       title: "No Data",
                                       description: "There is no step count data from the Health App")
            } else {
                Chart {
                    if let selectedHealthMetric {
                        RuleMark(x: .value("Selected Metric",
                                           selectedHealthMetric.date,
                                           unit: .day))
                        .offset(y: -10)
                        .annotation(position: .top,
                                    alignment: .center,
                                    spacing: 0,
                                    overflowResolution: .init(x: .fit(to: .chart))) {
                            annotationView
                        }
                    }
                    
                    RuleMark(y: .value("Average", averageSteps))
                        .foregroundStyle(.black.opacity(0.75))
                        .lineStyle(.init(lineWidth: 1, dash: [7]))
                    
                    ForEach(steps) { step in
                        BarMark(
                            x: .value("Date",
                                      step.date,
                                      unit: .day),
                            y: .value("Count", step.value)
                        )
                        .foregroundStyle(Color.cyan.gradient)
                        .opacity(selectedDate == nil || selectedHealthMetric?.date == step.date ? 1 : 0.2)
                    }
                }
                .foregroundStyle(.secondary.opacity(0.2))
                .chartXSelection(value: $selectedDate.animation(.easeInOut))
                .sensoryFeedback(.selection, trigger: selectedDate) { old, new in
                    guard let old, let new else { return false }
                    return old.weekdayInt != new.weekdayInt
                }
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel(format: .dateTime.day().month(.defaultDigits))
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisValueLabel((value.as(Double.self) ?? 0).formatted(.number.notation(.compactName)))
                    }
                }
            }
        }
                                     .frame(height: 220)
    }
    
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedHealthMetric?.date ?? .now, format: .dateTime.day().month(.abbreviated).weekday(.abbreviated))
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(selectedHealthMetric?.value ?? 0, format: .number.precision(.fractionLength(0)))
                .fontWeight(.heavy)
                .foregroundStyle(.cyan)
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(uiColor: .secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.2),radius: 1, x: 1, y: 1)
        }
    }
}

#Preview {
    StepChart(steps: HealthMockData.getSteps())
}
