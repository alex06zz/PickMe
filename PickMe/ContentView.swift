//
//  ContentView.swift
//  PickMe
//
//  Created by Alex Zuzuleac on 16/06/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("PickMe")
                    .font(.system(size: 50))
                    .foregroundColor(.purple)
                
                
                NavigationLink("Finger Picker") {
                    FingerPickerView()
                }
                
                NavigationLink("Team Picker") {
                    TeamPickerView()
                }
                
                Button("Settings") {
                }
            }
        }
    }
}
    

#Preview {
    ContentView()
}
