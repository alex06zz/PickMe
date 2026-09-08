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
    
    // Stores the selectd winner IDs
    @State private var selectedFingerIDs: Set<UUID> = []
    
    // Allows the countdown task to be cancelled if needed
    @State private var selectionTask: Task<Void, Never>?
    @State private var numberOfWinners = 1
    @State private var showingSettings = false
    @State private var countdownNumber: Int?
    
    // Used for animation
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
            
            // Instructions when not enough fingers on screen
            if fingers.isEmpty {
                Text("Place your fingers on the screen")
                    .foregroundColor(.white)
                    .font(.title2)
                    .allowsHitTesting(false)
            } else if fingers.count < numberOfWinners {
                Text("Place at least \(numberOfWinners) fingers")
                    .foregroundColor(.white)
                    .font(.title2)
                    .allowsHitTesting(false)
            }
            
            // Draw 1 coloured circle for every finger
            ForEach(fingers) { finger in
                if selectedFingerIDs.isEmpty || selectedFingerIDs.contains(finger.id) {
                    Circle()
                        .fill(
                            fingerColors[
                                // % keeps the index within the colour array
                                finger.colorIndex % fingerColors.count
                            ]
                        )
                        .frame(width: 100, height: 100)
                        .scaleEffect(
                            selectedFingerIDs.contains(finger.id) ? winnerScale : 1.0
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
            
            // Settings button in the top-right corner
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
                Spacer()
            }
        }
        
        // Runs when fingers are added or removed
        .onChange(of: fingers.map { $0.id }) { oldIDs, newIDs in
            
            // Reset when everyone lifts fingers
            if newIDs.isEmpty {
                selectionTask?.cancel()
                selectionTask = nil
                countdownNumber = nil
                selectedFingerIDs.removeAll()
                winnerScale = 1.0
                return
            }
            
            // Stop another selection after winners are chosen
            if !selectedFingerIDs.isEmpty {
                return
            }
            
            // Restart the countdown if the group of fingers changes
            selectionTask?.cancel()
            countdownNumber = nil
            
            // Start when enough fingers are on screen
            if newIDs.count >= max(2, numberOfWinners) {
                selectionTask = Task {
                    await chooseRandomFinger()
                    
                }
            }
        }
        // Opens finger picker settings
        .sheet(isPresented: $showingSettings) {
            FingerPickerSettingsView(
                numberOfWinners: $numberOfWinners
                )
        }
    }
    
    // MARK: - Finger Selection
    
    private func chooseRandomFinger() async {
        
        do {
            // Give time to place fingers
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
        
        // Make sure same group of fingers is still on screen
        guard fingers.count >= numberOfWinners,
              selectedFingerIDs.isEmpty
        else {
            countdownNumber = nil
            return
        }
        
        // randomly shuffle the fingers and take required number of winners
        let winners = fingers.shuffled().prefix(numberOfWinners)
        
        countdownNumber = nil
        
        // Store each selected winner
        for winner in winners {
            selectedFingerIDs.insert(winner.id)
        }
        
        winnerScale = 1.0
        
        withAnimation(.spring(duration: 0.5, bounce: 0.5)) {
            winnerScale = 1.5
        }
        
        playWinnerHaptic()
    }
    
    // MARK: - Animation
    
    private func animateCountdownNumber() {
        countdownScale = 1.5
        
        withAnimation(.easeOut(duration: 0.3)) {
            countdownScale = 1.0
        }
    }
    
    // MARK: - Haptics
    
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
