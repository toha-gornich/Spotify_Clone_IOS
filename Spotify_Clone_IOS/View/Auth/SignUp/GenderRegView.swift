//
//  GenderRegView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 11.08.2025.
//

import SwiftUI
struct GenderRegView: View {
    @ObservedObject var registrationData: RegistrationData
    @Environment(\.dismiss) private var dismiss
    @State private var showGenderPicker = false
    @State private var showUsernameView = false
    
    private let genderOptions = ["Female", "Male", "Prefer not to say", "Non-Binary"]
    
    // Встановлюємо "Female" як дефолт, якщо gender ще не вибраний
    private var displayGender: String {
        return registrationData.gender.isEmpty ? "Female" : registrationData.gender
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
                    VStack(alignment: .leading) {
                        
                        Spacer().frame(height: 40)
                        
                        // Title
                        Text("What's your gender?")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        Spacer().frame(height: 30)
                        
                        // Gender selection field
                        VStack(alignment: .leading, spacing: 8) {
                            Button(action: {
                                // Встановлюємо дефолтний gender перед відкриттям picker'а
                                if registrationData.gender.isEmpty {
                                    registrationData.gender = "Female"
                                }
                                showGenderPicker = true
                            }) {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.primaryText35)
                                        .frame(height: 56)
                                    
                                    HStack {
                                        Text(displayGender)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .padding(.horizontal)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                            .padding(.trailing)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            // Helper text
                            Text("This won't be shown on your profile.")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.horizontal)
                        }
                        
                        Spacer().frame(height: 40)
                        
                        // Next button
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                // Встановлюємо дефолт, якщо не вибрано
                                if registrationData.gender.isEmpty {
                                    registrationData.gender = "Female"
                                }
                                
                                showUsernameView = true
                                print("Gender button tapped - Navigating to username view")
                                print("Selected gender: \(registrationData.gender)")
                            }) {
                                Text("Next")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(width: 200, height: 56)
                                    .background(Color.white)
                                    .cornerRadius(28)
                            }
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showGenderPicker) {
            GenderPickerSheet(
                selectedGender: $registrationData.gender,
                showGenderPicker: $showGenderPicker,
                genderOptions: genderOptions
            )
        }
        .onAppear {
            // Встановлюємо дефолтний gender при завантаженні view
            if registrationData.gender.isEmpty {
                registrationData.gender = "Female"
            }
        }
        .navigationDestination(isPresented: $showUsernameView) {
            UsernameRegView(registrationData: registrationData)
        }
    }
}
