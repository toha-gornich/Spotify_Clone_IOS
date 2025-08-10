//
//  CreateAccountView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 03.08.2025.
//

import SwiftUI

struct EmailRegView: View {
    
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
                    VStack(alignment: .center) {
                        
                        
                        // Title
                        VStack(alignment: .leading) {
                            Text("What's your email?")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            // Email input field
                            VStack(alignment: .leading) {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.primaryText35)
                                        .frame(height: 56)
                                    
                                    HStack {
                                        TextField("", text: $email)
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
                                
                                Text("You'll need to confirm this email later.")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.horizontal)
                            }
                        }
                        
                        Spacer().frame(height: 40)
                        
                        Button(action: {
                            // Next action
                        }) {
                            Text("Next")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(email.isEmpty ? Color.primaryText80 : Color.primaryText80)
                                .cornerRadius(28)
                        }
                        .disabled(email.isEmpty)
                        .frame(width: 100)
                        
                        
                        
                        
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
    EmailRegView()
}
