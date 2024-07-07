//
//  HealthManagerError.swift
//  steps
//
//  Created by Julian Schenkemeyer on 07.07.24.
//

import Foundation


enum HealthManagerError: Error {
    case authorizationNotDetermined
    case sharingDenied
    case unableToCompleteRequest
}
