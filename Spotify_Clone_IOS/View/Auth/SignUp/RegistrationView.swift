//
//  RegisterView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 05.01.2026.
//

import SwiftUI

import SwiftUI

// MARK: - Email Registration View
struct EmailRegView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var registrationData = RegistrationData()
    @FocusState private var isEmailFocused: Bool
    @State private var showPasswordView = false
    
    var body: some View {
        VStack(alignment: .center) {
            ValidationInputField(
                title: "What's your email?",
                text: $registrationData.email,
                isValid: registrationData.isEmailValid,
                errorMessage: "Please enter a valid email address",
                helperText: "You'll need to confirm this email later.",
                keyboardType: .emailAddress,
                isFocused: $isEmailFocused
            )
            
            Spacer().frame(height: 40)
            
            RegistrationNextButton(
                title: "Next",
                isEnabled: registrationData.isEmailValid,
                action: { showPasswordView = true }
            )
            
            Spacer()
        }
        .registrationContainer(
            onBackTap: { dismiss() },
            isFocused: $isEmailFocused
        )
        .navigationDestination(isPresented: $showPasswordView) {
            PasswordRegView(registrationData: registrationData)
        }
    }
}

// MARK: - Password Registration View
struct PasswordRegView: View {
    @ObservedObject var registrationData: RegistrationData
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isPasswordFocused: Bool
    @State private var showConfirmPasswordView = false
    
    var body: some View {
        VStack(alignment: .center) {
            ValidationInputField(
                title: "Create a password",
                text: $registrationData.password,
                isValid: registrationData.isPasswordValid,
                errorMessage: "Password must be at least 8 characters long",
                helperText: "Use at least 8 characters.",
                isSecure: true,
                showVisibilityToggle: true,
                isFocused: $isPasswordFocused
            )
            
            Spacer().frame(height: 40)
            
            RegistrationNextButton(
                title: "Next",
                isEnabled: registrationData.isPasswordValid,
                action: { showConfirmPasswordView = true }
            )
            
            Spacer()
        }
        .registrationContainer(
            onBackTap: { dismiss() },
            isFocused: $isPasswordFocused
        )
        .navigationDestination(isPresented: $showConfirmPasswordView) {
            ConfirmPasswordRegView(registrationData: registrationData)
        }
    }
}

// MARK: - Confirm Password Registration View
struct ConfirmPasswordRegView: View {
    @ObservedObject var registrationData: RegistrationData
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isPasswordFocused: Bool
    @State private var showUsernameView = false
    
    var body: some View {
        VStack(alignment: .center) {
            ValidationInputField(
                title: "Repeat your password",
                text: $registrationData.confirmPassword,
                isValid: registrationData.doPasswordsMatch,
                errorMessage: "Passwords don't match",
                helperText: "Make sure it matches your password.",
                isSecure: true,
                showVisibilityToggle: true,
                isFocused: $isPasswordFocused
            )
            
            Spacer().frame(height: 40)
            
            RegistrationNextButton(
                title: "Next",
                isEnabled: registrationData.doPasswordsMatch,
                action: { showUsernameView = true }
            )
            
            Spacer()
        }
        .registrationContainer(
            onBackTap: { dismiss() },
            isFocused: $isPasswordFocused
        )
        .navigationDestination(isPresented: $showUsernameView) {
            UsernameRegView(registrationData: registrationData)
        }
    }
}

// MARK: - Username Registration View
struct UsernameRegView: View {
    @ObservedObject var registrationData: RegistrationData
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isUsernameFocused: Bool
    @State private var showAuthView = false
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer().frame(height: 40)
            
            ValidationInputField(
                title: "Create a username",
                text: $registrationData.username,
                isValid: registrationData.isUsernameValid,
                errorMessage: "Username must be at least 3 characters long.",
                helperText: "Username must be at least 3 characters long.",
                isDisabled: registrationData.isLoading,
                isFocused: $isUsernameFocused
            )
            
            Spacer().frame(height: 40)
            
            RegistrationNextButton(
                title: registrationData.isLoading ? "Registering..." : "Complete Registration",
                isEnabled: registrationData.isUsernameValid && !registrationData.isLoading,
                action: { handleRegistration() },
                isLoading: registrationData.isLoading,
                width: 280
            )
            
            Spacer()
        }
        .registrationContainer(
            onBackTap: {
                if !registrationData.isLoading {
                    dismiss()
                }
            },
            isFocused: $isUsernameFocused
        )
        .fullScreenCover(isPresented: $showAuthView) {
            NavigationStack {
                AuthView()
            }
        }
        .alert(item: $registrationData.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
    }
    
    private func handleRegistration() {
        Task {
            let success = await registrationData.registerUser()
            if success {
                await MainActor.run {
                    showAuthView = true
                }
            }
        }
    }
}

// MARK: - Previews
#Preview("Email") {
    NavigationStack {
        EmailRegView()
    }
}

#Preview("Password") {
    NavigationStack {
        PasswordRegView(registrationData: RegistrationData())
    }
}

#Preview("Confirm Password") {
    NavigationStack {
        ConfirmPasswordRegView(registrationData: RegistrationData())
    }
}

#Preview("Username") {
    NavigationStack {
        UsernameRegView(registrationData: RegistrationData())
    }
}
