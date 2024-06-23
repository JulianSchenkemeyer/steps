//
//  ChartMath.swift
//  steps
//
//  Created by Julian Schenkemeyer on 23.06.24.
//

import Foundation
import Algorithms


struct ChartMath {
    
    static func averageWeekdayCount(for metric: [HealthMetric]) -> [HealthMetric] {
        let sortedByWeekday = metric.sorted { $0.date.weekdayInt < $1.date.weekdayInt }
        let weekdaysChunked = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }
        
        var results: [HealthMetric] = []
        
        for weekday in weekdaysChunked {
            guard let first = weekday.first else { continue }
            let total = weekday.reduce(0) { $0 + $1.value }
            let average = total / Double(weekday.count)
            
            results.append(.init(date: first.date, value: average))
        }
        
        return results
    }
}
