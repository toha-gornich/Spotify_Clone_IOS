//
//  AuthView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.08.2025.
//


import SwiftUI

struct AuthView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var emailOrUsername: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    
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
                        
                        Text("Log in")
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
                        
                        // Email or username field
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Email or username")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.primaryText35)
                                    .frame(height: 56)
                                
                                HStack {
                                    TextField("", text: $emailOrUsername)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .focused($isEmailFocused)
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.emailAddress)
                                        .autocorrectionDisabled()
                                        .padding(.horizontal)
                                    
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Password field
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Password")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.primaryText35)
                                    .frame(height: 56)
                                
                                HStack {
                                    if isPasswordVisible {
                                        TextField("", text: $password)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .focused($isPasswordFocused)
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled()
                                            .padding(.horizontal)
                                    } else {
                                        SecureField("", text: $password)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .focused($isPasswordFocused)
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled()
                                            .padding(.horizontal)
                                    }
                                    
                                    Button(action: {
                                        isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                            .font(.system(size: 16))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    .padding(.trailing, 16)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer().frame(height: 40)
                        
                        // Login buttons
                        VStack( spacing: 16) {
                            // Main login button
                            Button(action: {
                                handleLogin()
                            }) {
                                Text("Log in")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(isLoginEnabled ? Color.primaryText80 : Color.primaryText80.opacity(0.5))
                                    .cornerRadius(28)
                            }
                            .disabled(!isLoginEnabled)
                            .frame(width: 100)
                            
                        }
                        
                        Spacer()
                    }
//                    .padding(.top, 32)
                }
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            isEmailFocused = false
            isPasswordFocused = false
        }
    }
    
    // MARK: - Computed Properties
    private var isLoginEnabled: Bool {
        !emailOrUsername.isEmpty && !password.isEmpty
    }
    
    // MARK: - Methods
    private func handleLogin() {
        // Handle login logic
        print("Login with email: \(emailOrUsername)")
    }
    
    private func handleLoginWithoutPassword() {
        // Handle login without password logic
        print("Login without password for: \(emailOrUsername)")
    }
}

#Preview {
    AuthView()
}
