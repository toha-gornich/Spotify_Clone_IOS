//
//  AccountView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 15.09.2025.
//

import SwiftUI

struct AccountView: View {
    @State private var email = "user1@gmail.com"
    @State private var displayName = "Mafan"
    @State private var selectedGender = "Male"
    @State private var selectedCountry = "Ukraine"
    @State private var password = ""
    @State private var showGenderPicker = false
    @State private var showCountryPicker = false
    
    private let genders = ["Male", "Female", "Other"]
    private let countries = ["Ukraine", "United States", "Canada", "United Kingdom", "Germany", "France", "Other"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    HStack {
                        Text("This is how others will see you on the site.")
                            .font(.body)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 20) {
                    
                    VStack(spacing: 16) {
                        
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.top, 20)
                    
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        TextField("", text: $email)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    .background(Color.clear)
                            )
                            .foregroundColor(.white)
                    }
                    
                    // Display Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Display Name")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        TextField("", text: $displayName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    .background(Color.clear)
                            )
                            .foregroundColor(.white)
                    }
                    
                    // Gender Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gender")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Button(action: {
                            showGenderPicker.toggle()
                        }) {
                            HStack {
                                Text(selectedGender)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    .background(Color.clear)
                            )
                        }
                        .actionSheet(isPresented: $showGenderPicker) {
                            ActionSheet(
                                title: Text("Select Gender"),
                                buttons: genders.map { gender in
                                    .default(Text(gender)) {
                                        selectedGender = gender
                                    }
                                } + [.cancel()]
                            )
                        }
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Country")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Button(action: {
                            showCountryPicker.toggle()
                        }) {
                            HStack {
                                Text(selectedCountry)
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    .background(Color.clear)
                            )
                        }
                        .actionSheet(isPresented: $showCountryPicker) {
                            ActionSheet(
                                title: Text("Select Country"),
                                buttons: countries.map { country in
                                    .default(Text(country)) {
                                        selectedCountry = country
                                    }
                                } + [.cancel()]
                            )
                        }
                    }
                    
                    
                    Button(action: {
                        // Update profile action
                    }) {
                        Text("Update profile")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    .padding(.top, 10)
                    
                    // Delete Account Section
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Delete account")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Enter your current password to delete your account.")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                
                                Text("WARNING: after deletion, all data will be invalidated. It is impossible to restore.")
                                    .font(.body)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        .background(Color.clear)
                                )
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                        }) {
                            Text("Delete account")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.8))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color.bg)
    }
}

#Preview {
    AccountView()
}
