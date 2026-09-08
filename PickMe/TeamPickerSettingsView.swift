//
//  TeamPickerSettingsView.swift
//  PickMe
//
//  Created by Alex Zuzuleac on 08/09/2026.
//

import SwiftUI

struct TeamPickerSettingsView: View {
    
    @Binding var numberOfTeams: Int
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Teams") {
                    Stepper("Number  of Teams: \(numberOfTeams)", value: $numberOfTeams, in: 2...10)
                }
            }
            .navigationTitle("Team Picker Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    TeamPickerSettingsView( numberOfTeams: .constant(2))
}

