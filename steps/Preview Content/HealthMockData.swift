//
//  StepsMockData.swift
//  steps
//
//  Created by Julian Schenkemeyer on 22.06.24.
//

import Foundation

struct HealthMockData {
    static func getSteps() -> [HealthMetric] {
        var result: [HealthMetric] = []
        for i in 0..<28 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: .now)!
            let metric = HealthMetric(date: date, value: .random(in: 2_000...20_000))
            
            result.append(metric)
        }
        
        return result
    }
}
