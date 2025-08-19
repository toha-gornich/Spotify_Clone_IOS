//
//  LoginView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.08.2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.bg
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with back button
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // Main content
                    VStack(spacing: 40) {
                        // Spotify Logo (matching GreetingView style)
                        VStack(spacing: 40) {
                            // Logo
                            Image("Logo")
                                .resizable()
                                .frame(width: 80, height: 80)
                                
                            
                            // Title Text matching GreetingView style
                            VStack(spacing: 8) {
                                HStack {
                                    Text("Log in to Spotify")
                                        .font(.system(size: 32, weight: .bold, design: .default))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                    
                    Spacer()
                    
                    // Login buttons section
                    VStack(spacing: 16) {
                        // Continue with email button
                        NavigationLink(destination: AuthView()) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                
                                Text("Continue with email")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.green)
                            .cornerRadius(28)
                        }
                        // Continue with Google button
                        Button(action: {
                            // Google login action
                        }) {
                            HStack {
                                Image(systemName: "globe")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                
                                Text("Continue with Google")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
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
                        
                        // Continue with Facebook button
                        Button(action: {
                            // Facebook login action
                        }) {
                            HStack {
                                Image(systemName: "globe")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                
                                Text("Continue with Facebook")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
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
                        
                        // Continue with Apple button
                        Button(action: {
                            // Apple login action
                        }) {
                            HStack {
                                Image(systemName: "applelogo")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                
                                Text("Continue with Apple")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
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
                    
                    Spacer().frame(height: 32)
                    
                    // Sign up section
                    VStack(spacing: 16) {
                        Text("Don't have an account?")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign up")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .underline()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationView{
        LoginView()
    }
}
