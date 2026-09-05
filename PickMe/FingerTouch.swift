//
//  FingerTouch.swift
//  PickMe
//
//  Created by Alex Zuzuleac on 04/09/2026.
//

import SwiftUI

// Represents one finger currently touching the screen
struct FingerTouch: Identifiable {
    let id: UUID
    var position: CGPoint
    let colorIndex: Int
}
