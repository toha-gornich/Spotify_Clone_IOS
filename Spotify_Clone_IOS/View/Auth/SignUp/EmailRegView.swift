//
//  CreateAccountView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.08.2025.
//

import SwiftUI

struct EmailRegView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var registrationData = RegistrationData()
    @FocusState private var isEmailFocused: Bool
    @State private var showPasswordView = false
    
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
                    VStack(alignment: .center) {
                        
                        
                        // Title
                        VStack(alignment: .leading) {
                            Text("What's your email?")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            // Email input field
                            VStack(alignment: .leading, spacing: 8) {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.primaryText35)
                                        .frame(height: 56)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    !registrationData.email.isEmpty && !registrationData.isEmailValid ?
                                                    Color.red : Color.clear,
                                                    lineWidth: 1
                                                )
                                        )
                                    
                                    HStack {
                                        TextField("", text: $registrationData.email)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .focused($isEmailFocused)
                                            .textInputAutocapitalization(.never)
                                            .keyboardType(.emailAddress)
                                            .autocorrectionDisabled()
                                            .padding(.horizontal)
                                        
                                        Spacer()
                                        
                                        // Validation indicator
                                        if !registrationData.email.isEmpty {
                                            Image(systemName: registrationData.isEmailValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                .foregroundColor(registrationData.isEmailValid ? .green : .red)
                                                .padding(.trailing)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                // Error message or helper text
                                VStack(alignment: .leading, spacing: 4) {
                                    if !registrationData.email.isEmpty && !registrationData.isEmailValid {
                                        Text("Please enter a valid email address")
                                            .font(.system(size: 14))
                                            .foregroundColor(.red)
                                            .padding(.horizontal)
                                    } else {
                                        Text("You'll need to confirm this email later.")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white.opacity(0.7))
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        
                        Spacer().frame(height: 40)
                        
                        Button(action: {
                            // Navigate to password view
                            showPasswordView = true
                        }) {
                            Text("Next")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    registrationData.isEmailValid ?
                                    Color.white : Color.primaryText80
                                )
                                .cornerRadius(28)
                        }
                        .disabled(!registrationData.isEmailValid)
                        .frame(width: 200)
                        .opacity(registrationData.isEmailValid ? 1.0 : 0.6)
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            isEmailFocused = false
        }
        .navigationDestination(isPresented: $showPasswordView) {
            PasswordRegView(registrationData: registrationData)
        }
    }
}

#Preview {
    NavigationStack {
        EmailRegView()
    }
}
