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
    
    func getAuthorizationStatus() -> HKAuthorizationStatus {
        store.authorizationStatus(for: HKQuantityType(.stepCount))
    }
    
    func fetchStepsData() async throws -> [HealthMetric] {
        guard getAuthorizationStatus() != .notDetermined else {
            throw HealthManagerError.authorizationNotDetermined
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let end = calendar.date(byAdding: .day, value: 1, to: today)!
        let start = calendar.date(byAdding: .day, value: -28, to: today)!
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: start, end: end)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.stepCount),
                                                               predicate: queryPredicate)
        let stepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                               options: .cumulativeSum,
                                                               anchorDate: end,
                                                               intervalComponents: .init(day: 1))
        
        do {
            let result = try await stepsQuery.result(for: store)
            let healthMetrics = result.statistics().map {
                HealthMetric(date: $0.startDate, value: $0.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            }
            
            return healthMetrics
        } catch {
            throw HealthManagerError.unableToCompleteRequest
        }
    }
    
    func addStepData(date: Date, value: Double) async throws {
        let status = getAuthorizationStatus()
        switch status {
        case .notDetermined:
            throw HealthManagerError.authorizationNotDetermined
        case .sharingDenied:
            throw HealthManagerError.sharingDenied
        case .sharingAuthorized:
            break
        @unknown default:
            break
        }
        
        let stepValue = HKQuantity(unit: .count(), doubleValue: value)
        let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepValue, start: date, end: date)
        
        do {
            try await store.save(stepSample)
        } catch {
            throw HealthManagerError.unableToCompleteRequest
        }
    }
    
#if targetEnvironment(simulator)
    func addMockData() async {
        var mockSample: [HKQuantitySample] = []
        
        for i in 0..<5 {
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
