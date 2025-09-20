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
                        Button(action: {
                            accountVM.showImagePicker = true
                        }) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 200, height: 200)
                                .overlay(
                                    Group {
                                        if let selectedImage = accountVM.selectedImage {
                                            Image(uiImage: selectedImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 200, height: 200)
                                                .clipShape(Circle())
                                        } else {
                                            SpotifyRemoteImage(urlString: accountVM.user.image ?? "")
                                                .frame(width: 200, height: 200)
                                                .clipShape(Circle())
                                        }
                                    }
                                )
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                        .padding(8)
                                    , alignment: .bottomTrailing
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.top, 20)
                    .sheet(isPresented: $accountVM.showImagePicker) {
                        ImagePicker(selectedImage: $accountVM.selectedImage)
                    }
                    
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
                    
                    // Country Picker
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
                                countries: accountVM.countries
                            )
                        }
                    }
                    
                    
                    
                    // Update Profile Button
                    Button(action: {
                        accountVM.updateProfile()
                    }) {
                        HStack {
                            if accountVM.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.black)
                            }
                            
                            Text("Update profile")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            accountVM.canUpdateProfile ?
                            Color.green :
                            Color.green.opacity(0.5)
                        )
                        .cornerRadius(8)
                        .scaleEffect(accountVM.canUpdateProfile ? 1.0 : 0.95)
                        .opacity(accountVM.canUpdateProfile ? 1.0 : 0.6)
                    }
                    .disabled(!accountVM.canUpdateProfile || accountVM.isLoading)
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
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .keyboardType(.default)
                        }
                        
                        Button(action: {
                            accountVM.deleteAccount()
                            accountVM.showGreeting = true
                        }) {
                            HStack {
                                if accountVM.isDeletingAccount {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .foregroundColor(.white)
                                }
                                
                                Text("Delete account")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                accountVM.canDeleteAccount ?
                                Color.red.opacity(0.8) :
                                Color.red.opacity(0.4)
                            )
                            .cornerRadius(8)
                            .scaleEffect(accountVM.canDeleteAccount ? 1.0 : 0.95)
                            .opacity(accountVM.canDeleteAccount ? 1.0 : 0.6)
                        }
                        .disabled(!accountVM.canDeleteAccount || accountVM.isDeletingAccount)
                        .fullScreenCover(isPresented: $accountVM.showGreeting) {
                            GreetingView()
                                .onDisappear {
                                    accountVM.showGreeting = false
                                }
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .onAppear() {
                accountVM.getUserMe()
                accountVM.loadUserData()
            }
        }
        .background(Color.bg)
    }
        
}
#Preview {
    AccountView()
}
