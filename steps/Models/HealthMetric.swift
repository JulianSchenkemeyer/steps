//
//  HealthMetric.swift
//  steps
//
//  Created by Julian Schenkemeyer on 17.06.24.
//

import Foundation


struct HealthMetric: Identifiable, Equatable {
    let id = UUID()
    
    let date: Date
    let value: Double
}
