//
//  HealthDataListScreen.swift
//  steps
//
//  Created by Julian Schenkemeyer on 16.06.24.
//

import SwiftUI

struct HealthDataListScreen: View {
    @State private var isShowingAddData = false
    
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
        .sheet(isPresented: $isShowingAddData) {
            AddNewHealthDataSheet()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingAddData = true
                } label: {
                    Label("Add Data", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataListScreen(healthMetric: "Steps")
    }
}
