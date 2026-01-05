//
//  AuthView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 10.08.2025.
//


import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @State private var showMainView = false
    @State private var isShowingSignUp = false
    var body: some View {
        
        ZStack {
            // Background
            Color.bg
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
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
                                TextField("", text: $viewModel.emailOrUsername)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .focused($isEmailFocused)
                                    .textInputAutocapitalization(.never)
                                    .keyboardType(.emailAddress)
                                    .autocorrectionDisabled()
                                    .padding(.horizontal)
                                    .disabled(viewModel.isLoading)
                                
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
                                if viewModel.isPasswordVisible {
                                    TextField("", text: $viewModel.password)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .focused($isPasswordFocused)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                        .padding(.horizontal)
                                        .disabled(viewModel.isLoading)
                                } else {
                                    SecureField("", text: $viewModel.password)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .focused($isPasswordFocused)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                        .padding(.horizontal)
                                        .disabled(viewModel.isLoading)
                                }
                                
                                Button(action: {
                                    viewModel.togglePasswordVisibility()
                                }) {
                                    Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .disabled(viewModel.isLoading)
                                .padding(.trailing, 16)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer().frame(height: 40)
                    
                    // Login button
                    Button(action: {
                        handleLogin()
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .scaleEffect(0.8)
                                Text("Logging in...")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                            } else {
                                Text("Log in")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            (viewModel.isLoginEnabled && !viewModel.isLoading) ?
                            Color.primaryText80 : Color.primaryText80.opacity(0.5)
                        )
                        .cornerRadius(28)
                    }
                    .disabled(!viewModel.isLoginEnabled || viewModel.isLoading)
                    .frame(width: 280)
                    .opacity((viewModel.isLoginEnabled && !viewModel.isLoading) ? 1.0 : 0.6)
                    
                    Spacer().frame(height: 30)
                    
                    // Additional links section
                    VStack(spacing: 24) {
                        // Forgot password link
                        Button(action: {
                            handleForgotPassword()
                        }) {
                            Text("Forgot your password?")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .underline()
                        }
                        .disabled(viewModel.isLoading)
                        
                        // Divider line
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 1)
                            .padding(.horizontal, 40)
                        
                        // Sign up link
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Button(action: {
                                isShowingSignUp = true
                            }) {
                                Text("Sign up for Spotify")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .underline()
                            }
                            .disabled(viewModel.isLoading)
                        }
                        
                        
                        // Resend activation code
                        VStack(spacing: 8) {
                            Text("Haven't received the email with the activation code?")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            
                            Button(action: {
                                handleResendActivation()
                            }) {
                                Text("Resend Activation Code")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .underline()
                            }
                            .disabled(viewModel.isLoading)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        
        .navigationBarHidden(true)
        .onTapGesture {
            if !viewModel.isLoading {
                isEmailFocused = false
                isPasswordFocused = false
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: alertItem.title,
                message: alertItem.message,
                dismissButton: alertItem.dismissButton
            )
        }
        .fullScreenCover(isPresented: $showMainView) {
            NavigationStack{
                MainView()
            }
        }
        .fullScreenCover(isPresented: $isShowingSignUp) {
            NavigationStack{
                SignUpView()
            }
        }
    }
    
    // MARK: - Action Methodуs
    private func handleLogin() {
        Task {
            let success = await viewModel.login()
            if success {
                // Navigate to MainView on successful login
                await MainActor.run {
                    showMainView = true
                }
            }
        }
    }
    
    private func handleForgotPassword() {
        //        Task {
        //            await viewModel.forgotPassword()
        //        }
    }
    
    //    private func handleSignUp() {
    //
    //    }
    
    private func handleResendActivation() {
        //        Task {
        //            await viewModel.resendActivationCode()
        //        }
    }
}

#Preview {
    NavigationStack{
        AuthView()
    }
}

