//
//  AccountView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 15.09.2025.
//

import SwiftUI

struct AccountView: View {
    @StateObject private var accountVM = AccountViewModel()
    
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
                        
                        TextField("", text: $accountVM.email)
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
                        
                        TextField("", text: $accountVM.displayName)
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
                            accountVM.showGenderSheet()
                        }) {
                            HStack {
                                Text(accountVM.selectedGender)
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
                        .sheet(isPresented: $accountVM.showGenderPicker) {
                            GenderPickerSheet(
                                selectedGender: $accountVM.selectedGender,
                                showGenderPicker: $accountVM.showGenderPicker,
                                genderOptions: accountVM.genders
                            )
                        }
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Country")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Button(action: {
                            accountVM.showCountrySheet()
                        }) {
                            HStack {
                                Text(accountVM.selectedCountry)
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
                        .sheet(isPresented: $accountVM.showCountryPicker) {
                            CountryPickerSheet(
                                selectedCountry: $accountVM.selectedCountry,
                                showCountryPicker: $accountVM.showCountryPicker,
                                countryOptions: accountVM.countries
                            )
                        }
                    }
                    .task() {
                        accountVM.getUserMe()
                    }
                    
                    
                    Button(action: {
                        accountVM.updateProfile()
                    }) {
                        Text("Update profile")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(accountVM.canUpdateProfile ? Color.green : Color.green.opacity(0.5))
                            .cornerRadius(8)
                    }
                    .disabled(!accountVM.canUpdateProfile)
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
                            
                            SecureField("Password", text: $accountVM.password)
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
                                .background(accountVM.canDeleteAccount ? Color.red.opacity(0.8) : Color.red.opacity(0.4))
                                .cornerRadius(8)
                        }
                        .disabled(!accountVM.canDeleteAccount)
                        
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
