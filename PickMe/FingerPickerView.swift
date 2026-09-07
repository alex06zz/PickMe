//
//  FingerPickerView.swift
//  PickMe
//
//  Created by Alex Zuzuleac on 02/09/2026.
//

import SwiftUI
import UIKit

// MARK: - Finger Picker Screen

struct FingerPickerView: View {
    // Stores all fingers on screen
    @State private var fingers: [FingerTouch] = []
    @State private var selectedFingerID: UUID?
    @State private var selectionTask: Task<Void, Never>?
    @State private var countdownNumber: Int?
    @State private var countdownScale: CGFloat = 1.0
    @State private var winnerScale: CGFloat = 1.0
    
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
                        .scaleEffect(
                            selectedFingerID == finger.id ? winnerScale : 1.0
                        )
                        .position(finger.position)
                    // Allows touches to pass through the circles
                        .allowsHitTesting(false)
                }
            }
            
            // Display countdown in the centre of the screen
            
            if let countdownNumber {
                Text("\(countdownNumber)")
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(countdownScale)
                    .allowsHitTesting(false)
            }
        }
        .onChange(of: fingers.map { $0.id }) { oldIDs, newIDs in
            
            if newIDs.isEmpty {
                selectionTask?.cancel()
                selectionTask = nil
                countdownNumber = nil
                selectedFingerID = nil
                winnerScale = 1.0
                return
            }
            
            if selectedFingerID != nil {
                return
            }
            
            selectionTask?.cancel()
            countdownNumber = nil
            
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
            try await Task.sleep(for: .seconds(1))
            
            // start countdown
            countdownNumber = 3
            animateCountdownNumber()
            playLightHaptic()
            
            try await Task.sleep(for: .seconds(1))
            countdownNumber = 2
            animateCountdownNumber()
            playLightHaptic()
            
            try await Task.sleep(for: .seconds(1))
            countdownNumber = 1
            animateCountdownNumber()
            playLightHaptic()
            
            try await Task.sleep(for: .seconds(1))
            
        } catch {
            //The finger group changed so the task cancelled
            countdownNumber = nil
            return
        }
        
        let currentFingerIDs = Set(fingers.map { $0.id })
        
        guard currentFingerIDs == startingFingerIDs,
              fingers.count >= 2,
              selectedFingerID == nil,
              let winner = fingers.randomElement()
        else {
            countdownNumber = nil
            return
        }
        countdownNumber = nil
        selectedFingerID = winner.id
        
        winnerScale = 1.0
        
        withAnimation(.spring(duration: 0.5, bounce: 0.5)) {
            winnerScale = 1.5
        }
        
        playWinnerHaptic()
    }
    
    private func animateCountdownNumber() {
        countdownScale = 1.5
        
        withAnimation(.easeOut(duration: 0.3)) {
            countdownScale = 1.0
        }
    }
    
    private func playLightHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    private func playWinnerHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}


// MARK: - Preview

#Preview {
    FingerPickerView()
}
