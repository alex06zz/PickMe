//
//  FingerPickerSettingsView.swift
//  PickMe
//
//  Created by Alex Zuzuleac on 07/09/2026.
//

import SwiftUI

struct FingerPickerSettingsView: View {
    
    @Binding var numberOfWinners: Int
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("Selection") {
                    Stepper("Number of Winners: \(numberOfWinners)", value: $numberOfWinners, in: 1...10
                    )
                }
            }
            .navigationTitle("Finger Picker Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FingerPickerSettingsView(numberOfWinners: .constant(1))
}
