//
//  HealthDataListScreen.swift
//  steps
//
//  Created by Julian Schenkemeyer on 16.06.24.
//

import SwiftUI

struct HealthDataListScreen: View {
    var healthMetric: String
    
    var body: some View {
        List(1..<28) { data in
            HStack {
                Text(Date(), format: .dateTime.month(.abbreviated)
                    .day(.twoDigits)
                    .year(.extended()))
                
                Spacer()
                
                Text((data * 10000), format: .number)
            }
        }
        .navigationTitle(healthMetric)
    }
}

#Preview {
    NavigationStack {
        HealthDataListScreen(healthMetric: "Steps")
    }
}
