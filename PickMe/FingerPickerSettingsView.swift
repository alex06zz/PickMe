//
//  FingerPickerSettingsView.swift
//  PickMe
//
//  Created by Alex Zuzuleac on 07/09/2026.
//

import SwiftUI

struct FingerPickerSettingsView: View {
    
    @Binding var numberOfWinners: Int

    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            
            VStack(spacing: 28) {

                Spacer()
            
                Text("Finger Picker")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                
                Text("Number of Winners")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.75))

                HStack(spacing: 45) {

                    Button {
                        if numberOfWinners > 1 {
                            numberOfWinners -= 1
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 64, height: 64)
                            .background(.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    .disabled(numberOfWinners == 1)
                    .opacity(numberOfWinners == 1 ? 0.4 : 1.0)

                    
                    Text("\(numberOfWinners)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(minWidth: 70)

                    
                    Button {
                        if numberOfWinners < 10 {
                            numberOfWinners += 1
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 64, height: 64)
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                    }
                    .disabled(numberOfWinners == 10)
                    .opacity(numberOfWinners == 10 ? 0.4 : 1.0)
                }

                
                Text("Choose how many fingers will be selected.")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.white.opacity(0.55))
                    .multilineTextAlignment(.center)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 24)
        }
    }
}

#Preview {
    FingerPickerSettingsView(numberOfWinners: .constant(1))
}
