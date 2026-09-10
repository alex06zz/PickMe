//
//  ContentView.swift
//  PickMe
//
//  Created by Alex Zuzuleac on 16/06/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.black
                    .ignoresSafeArea()
                
                GeometryReader { geometry in
                    ZStack {
                        Circle()
                            .fill(.pink)
                            .frame(width: geometry.size.width * 0.22)
                            .blur(radius: 18)
                            .opacity(0.35)
                            .position(
                                x: geometry.size.width * 0.02,
                                y: geometry.size.height * 0.18
                            )

                        Circle()
                            .fill(.blue)
                            .frame(width: geometry.size.width * 0.18)
                            .blur(radius: 18)
                            .opacity(0.3)
                            .position(
                                x: geometry.size.width * 0.98,
                                y: geometry.size.height * 0.28
                            )

                        Circle()
                            .fill(.purple)
                            .frame(width: geometry.size.width * 0.20)
                            .blur(radius: 20)
                            .opacity(0.28)
                            .position(
                                x: geometry.size.width * 0.03,
                                y: geometry.size.height * 0.78
                            )

                        Circle()
                            .fill(.orange)
                            .frame(width: geometry.size.width * 0.24)
                            .blur(radius: 20)
                            .opacity(0.28)
                            .position(
                                x: geometry.size.width * 0.97,
                                y: geometry.size.height * 0.86
                            )
                    }
                    .allowsHitTesting(false)
                }
                
                VStack(spacing: 22) {
                    
                    Spacer()
                    
                    PickMeLogoView()
                    
                    Spacer()
                    
                    NavigationLink {
                        FingerPickerView()
                    } label: {
                        HStack(spacing: 20) {
                            
                            Image(systemName: "hand.point.up.left.fill")
                                .font(.system(size: 32))
                                .frame(width: 64, height: 64)
                                .background(.white.opacity(0.15))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Finger Picker")
                                    .font(.title2.bold())
                                
                                Text("Pick the winner")
                                    .font(.subheadline)
                                    .opacity(0.8)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.title2.bold())
                        }
                        .foregroundColor(.white)
                        .padding(25)
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                        .background(
                            LinearGradient(
                                colors: [
                                    .blue.opacity(0.95),
                                    .purple.opacity(0.95)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(
                            color: .purple.opacity(0.35),
                            radius: 18,
                            x: 0,
                            y: 8
                        )
                    }
                    .buttonStyle(PickMeCardStyle())
                    
                    NavigationLink {
                        TeamPickerView()
                    } label: {
                        HStack(spacing: 20) {
                            
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 26))
                                .frame(width: 64, height: 64)
                                .background(.white.opacity(0.15))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Team Picker")
                                    .font(.title2.bold())
                                
                                Text("Split into teams")
                                    .font(.subheadline)
                                    .opacity(0.8)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.title2.bold())
                        }
                        .foregroundColor(.white)
                        .padding(25)
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                        .background(
                            LinearGradient(
                                colors: [
                                    .pink.opacity(0.95),
                                    .orange.opacity(0.95)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(
                            color: .pink.opacity(0.30),
                            radius: 18,
                            x: 0,
                            y: 8
                        )
                    }
                    .buttonStyle(PickMeCardStyle())
                    Spacer()
                    
                    Spacer()
                        .frame(height: 20)
                }
                .padding(.horizontal, 28)
            }
        }
    }
}
    

#Preview {
    ContentView()
}
