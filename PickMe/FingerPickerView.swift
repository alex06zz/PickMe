//
//  FingerPickerView.swift
//  PickMe
//
//  Created by Alex Zuzuleac on 02/09/2026.
//

import SwiftUI


// MARK: - Finger Picker Screen

struct FingerPickerView: View {
    // Stores all fingers on screen
    @State private var fingers: [FingerTouch] = []
    @State private var selectedFingerID: UUID?
    @State private var selectionTask: Task<Void, Never>?
    
    private let fingerColors: [Color] = [
        .pink,
        .blue,
        .green,
        .orange,
        .purple,
        .yellow,
        .cyan,
        .mint,
        .red,
        .brown
    ]
    
    var body: some View {
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            // UIKit view responsible for detecting multiple touches
            MultiTouchView(fingers: $fingers)
            
            // Instructions when no fingers on screen
            if fingers.isEmpty {
                Text("Place your fingers on the screen")
                    .foregroundColor(.white)
                    .font(.title2)
                    .allowsHitTesting(false)
            }
            
            // Draw 1 coloured circle for every finger
            ForEach(fingers) { finger in
                if selectedFingerID == nil || selectedFingerID == finger.id {
                    Circle()
                        .fill(
                            fingerColors[
                                // % keeps the index within the colour array
                                finger.colorIndex % fingerColors.count
                            ]
                        )
                        .frame(width: 100, height: 100)
                        .position(finger.position)
                    // Allows touches to pass through the circles
                        .allowsHitTesting(false)
                }
            }
        }
        .onChange(of: fingers.map { $0.id }) { oldIDs, newIDs in
            
            if newIDs.isEmpty {
                selectionTask?.cancel()
                selectionTask = nil
                selectedFingerID = nil
                return
            }
            
            if selectedFingerID != nil {
                return
            }
            
            selectionTask?.cancel()
            
            
            if newIDs.count >= 2 {
                selectionTask = Task {
                    await chooseRandomFinger()
                    
                }
            }
        }
    }
    
    private func chooseRandomFinger() async {
        let startingFingerIDs = Set(fingers.map { $0.id })
        
        do {
            try await Task.sleep(for: .seconds(2))
        } catch {
            return
        }
            
        let currentFingerIDs = Set(fingers.map { $0.id })
            
        guard currentFingerIDs == startingFingerIDs,
              fingers.count >= 2,
              selectedFingerID == nil,
              let winner = fingers.randomElement()
        else {
            return
        }
        selectedFingerID = winner.id
    }
}


// MARK: - Preview

#Preview {
    FingerPickerView()
}
