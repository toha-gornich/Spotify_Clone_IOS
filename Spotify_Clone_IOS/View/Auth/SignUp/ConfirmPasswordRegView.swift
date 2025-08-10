//
//  ConfirmPasswordRegView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 08.08.2025.
//

import SwiftUI

struct ConfirmPasswordRegView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var confirmPassword: String = ""
    @State private var isPasswordVisible: Bool = false
    @FocusState private var isPasswordFocused: Bool
    
    let originalPassword: String
    
    var isPasswordMatching: Bool {
        return confirmPassword == originalPassword && !confirmPassword.isEmpty
    }
    
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
                            VStack(alignment: .leading) {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.primaryText35)
                                        .frame(height: 56)
                                    
                                    HStack {
                                        if isPasswordVisible {
                                            TextField("", text: $confirmPassword)
                                                .font(.system(size: 16))
                                                .foregroundColor(.white)
                                                .focused($isPasswordFocused)
                                                .textInputAutocapitalization(.never)
                                                .autocorrectionDisabled()
                                                .padding(.horizontal)
                                        } else {
                                            SecureField("", text: $confirmPassword)
                                                .font(.system(size: 16))
                                                .foregroundColor(.white)
                                                .focused($isPasswordFocused)
                                                .textInputAutocapitalization(.never)
                                                .autocorrectionDisabled()
                                                .padding(.horizontal)
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
                                        
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal)
                                
                                Text("Make sure it matches your password.")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.horizontal)
                            }
                        }
                        
                        Spacer().frame(height: 40)
                        
                        Button(action: {
                            // Complete registration action
                        }) {
                            Text("Next")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(isPasswordMatching ? Color.primaryText80 : Color.primaryText80)
                                .cornerRadius(28)
                        }
                        .disabled(!isPasswordMatching)
                        .frame(width: 100)
                        
                        
                        
                        
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
    ConfirmPasswordRegView(originalPassword: "testpassword123")
}
