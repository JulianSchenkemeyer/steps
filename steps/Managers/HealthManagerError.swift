//
//  HealthManagerError.swift
//  steps
//
//  Created by Julian Schenkemeyer on 07.07.24.
//

import Foundation


enum HealthManagerError: LocalizedError {
    case authorizationNotDetermined
    case sharingDenied
    case unableToCompleteRequest
    
    
    var errorDescription: String? {
        switch self {
        case .authorizationNotDetermined:
            "Need Access to Health Data"
        case .sharingDenied:
            "No Write Access"
        case .unableToCompleteRequest:
            "Unable to Complete Request"
        }
    }
    
    var failureReason: String {
        switch self {
        case .authorizationNotDetermined:
            "You have not given access to your Health data. Please go to Settings > Health > Data Access & Devices."
        case .sharingDenied:
            "You have denied access to upload your step data.\n\nYou can change this in Settings > Health > Data Access & Devices."
        case .unableToCompleteRequest:
            "We are unable to complete your request at this time.\n\nPlease try again later or contact support."
        }
    }
}
