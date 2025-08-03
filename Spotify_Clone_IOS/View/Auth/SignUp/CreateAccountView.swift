//
//  CreateAccountView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.08.2025.
//

import SwiftUI

struct CreateAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @FocusState private var isEmailFocused: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
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
                        
                        Text("Create account")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Invisible spacer to center the title
                        Color.clear
                            .frame(width: 44, height: 44)
                    }
                    .padding(.top, 10)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 20) {
                        Spacer().frame(height: 40)
                        
                        // Title
                        VStack(alignment: .leading, spacing: 20) {
                            Text("What's your email?")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            // Email input field
                            VStack(alignment: .leading, spacing: 12) {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 56)
                                    
                                    HStack {
                                        // Green cursor indicator
                                        if isEmailFocused && email.isEmpty {
                                            Rectangle()
                                                .fill(Color.green)
                                                .frame(width: 2, height: 24)
                                                .padding(.leading, 16)
                                        }
                                        
                                        TextField("", text: $email)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .focused($isEmailFocused)
                                            .textInputAutocapitalization(.never)
                                            .keyboardType(.emailAddress)
                                            .autocorrectionDisabled()
                                            .padding(.horizontal, 16)
                                        
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal, 24)
                                
                                Text("You'll need to confirm this email later.")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.horizontal, 24)
                            }
                        }
                        
                        Spacer()
                        
                        // Next button
                        VStack(spacing: 20) {
                            Button(action: {
                                // Next action
                            }) {
                                Text("Next")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(email.isEmpty ? Color.gray.opacity(0.5) : Color.gray.opacity(0.8))
                                    .cornerRadius(28)
                            }
                            .disabled(email.isEmpty)
                            .padding(.horizontal, 80)
                        }
                        .padding(.bottom, 40)
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            isEmailFocused = false
        }
    }
}

#Preview {
    CreateAccountView()
}
