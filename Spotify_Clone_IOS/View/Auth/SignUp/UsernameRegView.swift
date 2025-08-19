//
//  UsernameRegView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 16.08.2025.
//

import SwiftUI
struct UsernameRegView: View {
    @ObservedObject var registrationData: RegistrationData
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isUsernameFocused: Bool
    @State private var showAuthView = false
    
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
                        
                        Spacer().frame(height: 40)
                        
                        // Title
                        VStack(alignment: .leading) {
                            Text("Create a username")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            // Username input field
                            VStack(alignment: .leading, spacing: 8) {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.primaryText35)
                                        .frame(height: 56)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    !registrationData.username.isEmpty && !registrationData.isUsernameValid ?
                                                    Color.red : Color.clear,
                                                    lineWidth: 1
                                                )
                                        )
                                    
                                    HStack {
                                        TextField("", text: $registrationData.username)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .focused($isUsernameFocused)
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled()
                                            .padding(.horizontal)
                                            .disabled(registrationData.isLoading)
                                        
                                        Spacer()
                                        
                                        // Validation indicator
                                        if !registrationData.username.isEmpty {
                                            Image(systemName: registrationData.isUsernameValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                .foregroundColor(registrationData.isUsernameValid ? .green : .red)
                                                .padding(.trailing)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                // Error message or helper text
                                VStack(alignment: .leading, spacing: 4) {
                                    if !registrationData.username.isEmpty && !registrationData.isUsernameValid {
                                        Text("Username must be at least 3 characters long.")
                                            .font(.system(size: 14))
                                            .foregroundColor(.red)
                                            .padding(.horizontal)
                                    } else {
                                        Text("Username must be at least 3 characters long.")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white.opacity(0.7))
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        
                        Spacer().frame(height: 40)
                        
                        Button(action: {
                            if registrationData.isUsernameValid && !registrationData.isLoading {
                                handleRegistration()
                            }
                        }) {
                            HStack {
                                if registrationData.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                        .scaleEffect(0.8)
                                    Text("Registering...")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.black)
                                } else {
                                    Text("Complete Registration")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.black)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                (registrationData.isUsernameValid && !registrationData.isLoading) ? Color.white : Color.primaryText80
                            )
                            .cornerRadius(28)
                        }
                        .disabled(!registrationData.isUsernameValid || registrationData.isLoading)
                        .frame(width: 280)
                        .opacity((registrationData.isUsernameValid && !registrationData.isLoading) ? 1.0 : 0.6)
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            if !registrationData.isLoading {
                isUsernameFocused = false
            }
        }
        .fullScreenCover(isPresented: $showAuthView) {
            // CHANGED: Pass a flag to hide back button
            AuthView(hideBackButton: true)
        }
        .alert(item: $registrationData.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
    
    
    private func handleRegistration() {
        Task {
            let success = await registrationData.registerUser()
            
            if success {
                // Only show AuthView on successful registration
                await MainActor.run {
                    showAuthView = true
                }
            }
            // If registration fails, alertItem will be set and alert will show
        }
    }
}

#Preview {
    NavigationStack {
        UsernameRegView(registrationData: RegistrationData())
    }
}

