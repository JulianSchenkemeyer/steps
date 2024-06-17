//
//  HealthKitManager.swift
//  steps
//
//  Created by Julian Schenkemeyer on 17.06.24.
//

import Foundation
import HealthKit
import Observation


@Observable
class HealthKitManager {
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount)]
    
    #if targetEnvironment(simulator)
    func addMockData() async {
        var mockSample: [HKQuantitySample] = []
        
        for i in 0..<28 {
            let stepValue = HKQuantity(unit: .count(), doubleValue: .random(in: 2_000...20_000))
            let date = Calendar.current.date(byAdding: .day, value: -i, to: .now)!
            let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount),
                                              quantity: stepValue,
                                              start: date,
                                              end: date)
            
            mockSample.append(stepSample)
        }
        
        try! await store.save(mockSample)
    }
    #endif
}
