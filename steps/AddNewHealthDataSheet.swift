//
//  AddNewHealthData.swift
//  steps
//
//  Created by Julian Schenkemeyer on 16.06.24.
//

import SwiftUI

struct AddNewHealthDataSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var addDataDate: Date = .now
    @State private var addDataValue: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                TextField("Value", text: $addDataValue)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add new Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        // save
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        
    }
}

#Preview {
    Text("")
        .sheet(isPresented: .constant(true)) {
            AddNewHealthDataSheet()
        }
}
