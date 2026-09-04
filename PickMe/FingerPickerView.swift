//
//  FingerPickerView.swift
//  PickMe
//
//  Created by Alex Zuzuleac on 02/09/2026.
//

import SwiftUI
import UIKit


// MARK: - FINGER MODEL

// Represents ONE finger, ID, Position, Color
struct FingerTouch: Identifiable {
    let id: UUID
    var position: CGPoint
    let colorIndex: Int
}


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


// MARK: - SwiftUI / UIKit Bridge

// UIViewRepresentable allows us to put UIKit UIView inside SwiftUI
// FingerPickerView is SwiftUI, TouchView is UIKit. this struct bridges both
struct MultiTouchView: UIViewRepresentable {
    
    // Binding gives this view access to FingerPickerView's fingers array
    @Binding var fingers: [FingerTouch]
    
    // Creates the UIKit touch-detection view
    func makeUIView(context: Context) -> TouchView {
        
        let view = TouchView()
        view.isMultipleTouchEnabled = true
        
        // Send updated touches from UIKit back to SwiftUI
        view.onTouchesChanged = { newFingers in
            fingers = newFingers
        }
        
        return view
    }
    
    // Required by UIViewRepresentable.
    // Nothing needs updating from SwiftUI yet.
    func updateUIView(_ uiView: TouchView, context: Context) {
        // empty
    }
}


// MARK: - Multi-Touch Detection

class TouchView: UIView {
    
    // sends current finger back to SwiftUI when touches change
    var onTouchesChanged: (([FingerTouch]) -> Void)?
    
    // Maps each physical touch to its unique ID
    private var touchIDs: [ObjectIdentifier: UUID] = [:]
    
    // Maps each physical touch to its assigned colour
    private var touchColors: [ObjectIdentifier: Int] = [:]
    
    // Stores all physical touches currently on screen
    private var activeTouches: [ObjectIdentifier: UITouch] = [:]
    
    // Colour index to assign to the next new finger
    private var nextColorIndex = 0
    
    
    // MARK: Setup
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        isMultipleTouchEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Touch Events
    
    // Called when one or more new fingers touch screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = ObjectIdentifier(touch)
            
            // Give new finger ID and colour
            touchIDs[key] = UUID()
            touchColors[key] = nextColorIndex
            nextColorIndex += 1
            
            //Store it as an active touch
            activeTouches[key] = touch
        }
        
        updateFingers()
    }
    
    // Called when an existing finger moves
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = ObjectIdentifier(touch)
            activeTouches[key] = touch
        }
        
        updateFingers()
    }
    
    // Called when a finger is lifted
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeTouches(touches)
    }
    
    // Handles touches cancelled by iOS
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeTouches(touches)
    }
    
    
    // MARK: Update Fingers
    
    // Converts UIKit touches into FingerTouch objects for SwiftUI
    private func updateFingers() {
        
        var updatedFingers: [FingerTouch] = []
        
        for (key, touch) in activeTouches {
            
            // Get ID and colour assigned to this touch
            guard let id = touchIDs[key],
                  let colorIndex = touchColors[key]
            else {
                continue
            }
            
            // Get the fingers position
            let position = touch.location(in: self)
            
            // Create the FingerTouch and add it to the updated array
            updatedFingers.append(
                FingerTouch(
                    id: id,
                    position: position,
                    colorIndex: colorIndex
                )
            )
        }
        
        // Send the updated array back to SwiftUI
        onTouchesChanged?(updatedFingers)
    }
    
    // MARK: Remove Fingers
    
    // Removes fingers that are no longer needed
    private func removeTouches(_ touches: Set<UITouch>) {
        for touch in touches {
            let key = ObjectIdentifier(touch)
            
            activeTouches.removeValue(forKey: key)
            touchIDs.removeValue(forKey: key)
            touchColors.removeValue(forKey: key)
        }
        
        updateFingers()
        
        // Restart colour sequence when eveeryone lifts their fingers
        if activeTouches.isEmpty {
            nextColorIndex = 0
        }
    }
}


// MARK: - Preview

#Preview {
    FingerPickerView()
}
