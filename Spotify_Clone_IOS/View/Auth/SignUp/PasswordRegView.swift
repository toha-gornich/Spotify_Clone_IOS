//
//  PasswordRegView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 07.08.2025.
//

import SwiftUI

struct PasswordRegView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @Environment(\.dismiss) private var dismiss
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
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
                            Text("Create a password")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            // Password input field
                            VStack(alignment: .leading, spacing: 12) {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 56)
                                    
                                    HStack {
                                        // Green cursor indicator
                                        if isPasswordFocused && password.isEmpty {
                                            Rectangle()
                                                .fill(Color.green)
                                                .frame(width: 2, height: 24)
                                                .padding(.leading, 16)
                                        }
                                        
                                        if isPasswordVisible {
                                            TextField("", text: $password)
                                                .font(.system(size: 16))
                                                .foregroundColor(.white)
                                                .focused($isPasswordFocused)
                                                .textInputAutocapitalization(.never)
                                                .autocorrectionDisabled()
                                                .padding(.horizontal, 16)
                                        } else {
                                            SecureField("", text: $password)
                                                .font(.system(size: 16))
                                                .foregroundColor(.white)
                                                .focused($isPasswordFocused)
                                                .textInputAutocapitalization(.never)
                                                .autocorrectionDisabled()
                                                .padding(.horizontal, 16)
                                        }
                                        
                                        Spacer()
                                        
                                        // Eye icon for password visibility toggle
                                        Button(action: {
                                            isPasswordVisible.toggle()
                                        }) {
                                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                                .font(.system(size: 18))
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 16)
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                                
                                Text("Use at least 10 characters.")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.horizontal, 24)
                            }
                        }
                        
                        Spacer()
                        
                        // Next button
                        VStack(spacing: 20) {
                            Button(action: {
                                // Save password and navigate to next step
                                registrationData.password = password
                                // Add navigation logic here
                            }) {
                                Text("Next")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(password.count >= 10 ? Color.white : Color.gray.opacity(0.5))
                                    .cornerRadius(28)
                            }
                            .disabled(password.count < 10)
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
            isPasswordFocused = false
        }
    }
}

#Preview {
    PasswordRegView()
        .environmentObject(RegistrationData())
}
