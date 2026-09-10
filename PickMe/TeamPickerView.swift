//
//  TeamPickerView.swift
//  PickMe
//
//  Created by Alex Zuzuleac on 08/09/2026.
//

import SwiftUI
import UIKit

struct TeamPickerView: View {
    
    // Stores all fingers currently on screen
    @State private var fingers: [FingerTouch] = []
    
    // Stores each finger ID and its assigned team
    @State private var fingerTeams: [UUID: Int] = [:]
    
    // Team picker settings
    @State private var numberOfTeams = 2
    @State private var showingSettings = false
    
    // Countdown and reveal state
    @State private var selectionTask: Task<Void, Never>?
    @State private var countdownNumber: Int?
    @State private var countdownScale: CGFloat = 1.0
    @State private var teamRevealScale: CGFloat = 1.0
    
    // Colours shown before asigning teams
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
    
    // Colours used for the teams
    private let teamColors: [Color] = [
        .blue,
        .red,
        .green,
        .orange,
        .purple,
        .yellow,
        .cyan,
        .pink,
        .mint,
        .brown
    ]
    
    var body: some View {
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            // Detect multiple finger touches
            MultiTouchView(fingers: $fingers)
            
            if fingers.isEmpty {
                Text("Place your fingers on the screen")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.75))
                    .allowsHitTesting(false)
                    
            } else if fingers.count < numberOfTeams {
                Text("Place at least \(numberOfTeams) fingers")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.75))
                    .allowsHitTesting(false)
            }
            
            // Draw a coloured circle for each finger
            ForEach(fingers) { finger in
                Circle()
                    .fill(
                        fingerTeams[finger.id] != nil
                            ? teamColors[fingerTeams[finger.id]! % teamColors.count]
                            : fingerColors[finger.colorIndex % fingerColors.count]
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(
                        fingerTeams[finger.id] != nil ? teamRevealScale : 1.0
                    )
                    .position(finger.position)
                    .allowsHitTesting(false)
            }
            
            // Display countdown in the centre of the screen
            if let countdownNumber {
                Text("\(countdownNumber)")
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(countdownScale)
                    .allowsHitTesting(false)
            }
            
            // Team Picker settings button
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size:20))
                            .foregroundColor(.white.opacity(0.85))
                            .frame(width: 48, height: 48)
                            .background(.white.opacity(0.12))
                            .clipShape(Circle())
                            .padding()
                    }
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingSettings) {
            TeamPickerSettingsView(
                numberOfTeams: $numberOfTeams
            )
        }
        .onChange(of: fingers.map { $0.id }) { oldIDs, newIDs in
            
            // Reset when everyone lifts their fingers
            if newIDs.isEmpty {
                selectionTask?.cancel()
                selectionTask = nil
                countdownNumber = nil
                teamRevealScale = 1.0
                fingerTeams.removeAll()
                return
            }
            
            // Cancel the current countdown if fingers change
            selectionTask?.cancel()
            countdownNumber = nil
            fingerTeams.removeAll()
            teamRevealScale = 1.0
            
            // Start when there are enough fingers for the selected teams
            if newIDs.count >= numberOfTeams {
                selectionTask = Task {
                    await startTeamSelection()
                }
            }
        }
    }
    
    private func startTeamSelection() async {
        
        do {
            try await Task.sleep(for: .seconds(1))
            
            // Start countdown
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
            // Countdown cancelled because fingers changed
            countdownNumber = nil
            return
        }
        
        countdownNumber = nil
        
        teamRevealScale = 1.0
        assignTeams()
        
        withAnimation(.spring(duration: 0.5, bounce: 0.5)) {
            teamRevealScale = 1.4
        }
        
        playTeamRevealHaptic()
    }
    
    private func assignTeams() {
        
        // Randomise the order of the fingers
        let shuffledFingers = fingers.shuffled()
        
        fingerTeams.removeAll()
        
        // Assign each finger to a team
        for (index, finger) in shuffledFingers.enumerated() {
            let team = index % numberOfTeams
            fingerTeams[finger.id] = team
        }
    }
    
    private func animateCountdownNumber() {
        countdownScale = 1.5
        
        withAnimation(.easeOut(duration: 0.3)) {
            countdownScale = 1.0
        }
    }
    
    // Light feedback during countdown
    private func playLightHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    // Stronger feedback when teams revealed
    private func playTeamRevealHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

#Preview {
    TeamPickerView()
}

