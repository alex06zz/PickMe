//
//  PickMeCardStyle.swift
//  PickMe
//
//  Created by Alex Zuzuleac on 10/09/2026.
//

import SwiftUI

struct PickMeCardStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(
                .easeOut(duration: 0.15),
                value: configuration.isPressed
            )
    }
}
