//
//  TeamPickerSettingsView.swift
//  PickMe
//
//  Created by Alex Zuzuleac on 08/09/2026.
//

import SwiftUI

struct TeamPickerSettingsView: View {
    
    @Binding var numberOfTeams: Int
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                
                Spacer()
                
                Text("Team Picker")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Number of Teams")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.75))
                
                HStack(spacing: 45) {
                    
                    Button {
                        if numberOfTeams > 2 {
                            numberOfTeams -= 1
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 64, height: 64)
                            .background(.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    .disabled(numberOfTeams == 2)
                    .opacity(numberOfTeams == 2 ? 0.4 : 1.0)
                    
                    Text("\(numberOfTeams)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(minWidth: 70)
                    
                    Button {
                        if numberOfTeams < 10 {
                            numberOfTeams += 1
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 64, height: 64)
                            .background(
                                LinearGradient(
                                    colors: [.pink, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                    }
                    .disabled(numberOfTeams == 10)
                    .opacity(numberOfTeams == 10 ? 0.4 : 1.0)
                }
                
                Text("Choose how many teams to split everyone into.")
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
                                colors: [.pink, .orange],
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
    TeamPickerSettingsView(numberOfTeams: .constant(2))
}
