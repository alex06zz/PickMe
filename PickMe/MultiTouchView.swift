//
//  MultiTouchView.swift
//  PickMe
//
//  Created by Alex Zuzuleac on 05/09/2026.
//

import SwiftUI
import UIKit

// MARK: - SwiftUI / UIKit Bridge

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
