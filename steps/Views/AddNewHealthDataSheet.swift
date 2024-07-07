//
//  AddNewHealthData.swift
//  steps
//
//  Created by Julian Schenkemeyer on 16.06.24.
//

import SwiftUI

struct AddNewHealthDataSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(HealthKitManager.self) private var hkManager
    
    @State private var addDataDate: Date = .now
    @State private var addDataValue: String = ""
    @State private var isShowingError = false
    @State private var healthManagerError: HealthManagerError = .unableToCompleteRequest
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                HStack {
                    Text("Steps")
                    Spacer()
                    TextField("Value", text: $addDataValue)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                }
            }
            .navigationTitle("Add new Data")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $isShowingError, error: healthManagerError, actions: { healthManagerError in
                switch healthManagerError {
                case .authorizationNotDetermined, .unableToCompleteRequest:
                    EmptyView()
                case .sharingDenied:
                    Button("Settings") {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    
                    Button("Cancel", role: .cancel) { }
                }

            }, message: { healthManagerError in
                Text(healthManagerError.failureReason)
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        Task {
                            do {
                                guard let value = Double(addDataValue) else { return }
                                
                                try await hkManager.addStepData(date: addDataDate ,value: value)
                                dismiss()
                            } catch HealthManagerError.sharingDenied {
                                healthManagerError = .sharingDenied
                                isShowingError = true
                            } catch {
                                healthManagerError = .unableToCompleteRequest
                                isShowingError = true
                            }
                        }
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
                .environment(HealthKitManager())
        }
}
