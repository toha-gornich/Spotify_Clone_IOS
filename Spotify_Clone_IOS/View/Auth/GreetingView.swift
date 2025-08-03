//
//  GreetingView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.08.2025.
//

import SwiftUI

struct GreetingView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Background
                    Color.bg
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        Spacer()
                        
                        // Spotify Logo
                        VStack(spacing: 40) {
                            
                            // Logo
                            Image("Logo")
                                .resizable()
                                .frame(width: 80, height: 80)
                           
                            
                            // Title Text with custom styling
                            VStack(spacing: 8) {
                                HStack {
                                    Text("Millions of songs.")
                                        .font(.system(size: 32, weight: .bold, design: .default))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                }
                                
                                HStack {
                                    Text("Free on Spotify.")
                                        .font(.system(size: 32, weight: .bold, design: .default))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                        
                        Spacer()
                        
                        // Buttons Section
                        VStack(spacing: 16) {
                            // Sign up button
                            NavigationLink(destination: SignUpView()) {
                                Text("Sign up for free")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(Color.green)
                                    .cornerRadius(28)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Log in button
                            NavigationLink(destination: LoginView()) {
                                Text("Log in")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(Color.clear)
                                    .contentShape(Rectangle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 28)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                                    .cornerRadius(28)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                        
                        // Bottom indicator
                        RoundedRectangle(cornerRadius: 2.5)
                            .fill(Color.white)
                            .frame(width: 134, height: 5)
                            .padding(.bottom, 8)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


#Preview {
    NavigationView{
        GreetingView()
    }
}
