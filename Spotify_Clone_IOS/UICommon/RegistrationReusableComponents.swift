//
//  RegistrationReusableComponents.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 05.01.2026.
//

import SwiftUI

// MARK: - Registration Container Modifier
struct RegistrationContainerModifier: ViewModifier {
    let onBackTap: () -> Void
    @FocusState.Binding var isFocused: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                RegistrationHeaderView(onBackTap: onBackTap)
                content
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            isFocused = false
        }
    }
}

// MARK: - Extension for easy usage
extension View {
    func registrationContainer(
        onBackTap: @escaping () -> Void,
        isFocused: FocusState<Bool>.Binding
    ) -> some View {
        self.modifier(RegistrationContainerModifier(
            onBackTap: onBackTap,
            isFocused: isFocused
        ))
    }
}

// MARK: - Registration Header
struct RegistrationHeaderView: View {
    let onBackTap: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBackTap) {
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
            
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.top, 10)
    }
}

// MARK: - Validation Input Field
struct ValidationInputField: View {
    let title: String
    @Binding var text: String
    let isValid: Bool
    let errorMessage: String
    let helperText: String
    var isSecure: Bool = false
    var showVisibilityToggle: Bool = false
    var keyboardType: UIKeyboardType = .default
    var isDisabled: Bool = false
    @FocusState.Binding var isFocused: Bool
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primaryText35)
                        .frame(height: 56)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    !text.isEmpty && !isValid ? Color.red : Color.clear,
                                    lineWidth: 1
                                )
                        )
                    
                    HStack {
                        if isSecure && !isPasswordVisible {
                            SecureField("", text: $text)
                                .inputFieldStyle(isFocused: $isFocused, isDisabled: isDisabled)
                        } else {
                            TextField("", text: $text)
                                .keyboardType(keyboardType)
                                .inputFieldStyle(isFocused: $isFocused, isDisabled: isDisabled)
                        }
                        
                        Spacer()
                        
                        if !text.isEmpty {
                            Image(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(isValid ? .green : .red)
                                .padding(.trailing, showVisibilityToggle ? 4 : 12)
                        }
                        
                        if showVisibilityToggle {
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
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 4) {
                    if !text.isEmpty && !isValid {
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    } else {
                        Text(helperText)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

// MARK: - Input Field Style Helper
extension View {
    func inputFieldStyle(isFocused: FocusState<Bool>.Binding, isDisabled: Bool) -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(.white)
            .focused(isFocused)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(.horizontal)
            .disabled(isDisabled)
    }
}

// MARK: - Registration Next Button
struct RegistrationNextButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    var isLoading: Bool = false
    var width: CGFloat = 200
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(0.8)
                }
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(isEnabled ? Color.white : Color.primaryText80)
            .cornerRadius(28)
        }
        .disabled(!isEnabled || isLoading)
        .frame(width: width)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}
