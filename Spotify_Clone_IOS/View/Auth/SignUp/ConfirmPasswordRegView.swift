//
//  ConfirmPasswordRegView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 08.08.2025.
//

import SwiftUI

struct ConfirmPasswordRegView: View {
    @ObservedObject var registrationData: RegistrationData
    @Environment(\.dismiss) private var dismiss
    @State private var isPasswordVisible: Bool = false
    @FocusState private var isPasswordFocused: Bool
    @State private var showDateOfBirthView = false
    
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
                            Text("Repeat your password")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            // Password input field
                            VStack(alignment: .leading, spacing: 8) {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.primaryText35)
                                        .frame(height: 56)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    !registrationData.confirmPassword.isEmpty && !registrationData.doPasswordsMatch ?
                                                    Color.red : Color.clear,
                                                    lineWidth: 1
                                                )
                                        )
                                    
                                    HStack {
                                        if isPasswordVisible {
                                            TextField("", text: $registrationData.confirmPassword)
                                                .font(.system(size: 16))
                                                .foregroundColor(.white)
                                                .focused($isPasswordFocused)
                                                .textInputAutocapitalization(.never)
                                                .autocorrectionDisabled()
                                                .padding(.horizontal)
                                        } else {
                                            SecureField("", text: $registrationData.confirmPassword)
                                                .font(.system(size: 16))
                                                .foregroundColor(.white)
                                                .focused($isPasswordFocused)
                                                .textInputAutocapitalization(.never)
                                                .autocorrectionDisabled()
                                                .padding(.horizontal)
                                        }
                                        
                                        Spacer()
                                        
                                        // Validation indicator
                                        if !registrationData.confirmPassword.isEmpty {
                                            Image(systemName: registrationData.doPasswordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                .foregroundColor(registrationData.doPasswordsMatch ? .green : .red)
                                                .padding(.trailing, 12)
                                        }
                                        
                                        // Eye icon for password visibility toggle
                                        Button(action: {
                                            isPasswordVisible.toggle()
                                        }) {
                                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                                .font(.system(size: 18))
                                                .foregroundColor(.gray)
                                                .padding(.trailing)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                // Error message or helper text
                                VStack(alignment: .leading, spacing: 4) {
                                    if !registrationData.confirmPassword.isEmpty && !registrationData.doPasswordsMatch {
                                        Text("Passwords don't match")
                                            .font(.system(size: 14))
                                            .foregroundColor(.red)
                                            .padding(.horizontal)
                                    } else {
                                        Text("Make sure it matches your password.")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white.opacity(0.7))
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        
                        Spacer().frame(height: 40)
                        
                        Button(action: {
                            
                            if registrationData.doPasswordsMatch {
                                showDateOfBirthView = true
                                print("Navigating to date of birth view")
                            }
                        }) {
                            Text("Next")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    registrationData.doPasswordsMatch ?
                                    Color.white : Color.primaryText80
                                )
                                .cornerRadius(28)
                        }
                        .disabled(!registrationData.doPasswordsMatch)
                        .frame(width: 200)
                        .opacity(registrationData.doPasswordsMatch ? 1.0 : 0.6)
                        
                        Spacer()
                        
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            isPasswordFocused = false
        }
        .navigationDestination(isPresented: $showDateOfBirthView) {
            UsernameRegView(registrationData: registrationData)
        }
    }
}


#Preview {
    NavigationStack {
        ConfirmPasswordRegView(registrationData: RegistrationData())
    }
}
