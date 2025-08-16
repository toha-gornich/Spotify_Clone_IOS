//
//  DateOfBirthRegView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 11.08.2025.
//

import SwiftUI


struct DateOfBirthRegView: View {
    @ObservedObject var registrationData: RegistrationData
    @Environment(\.dismiss) private var dismiss
    @State private var showDatePicker = false
    @State private var showGenderView = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }
    
    // Перевірка чи користувач досяг 13 років
    private var isValidAge: Bool {
        let calendar = Calendar.current
        let thirteenYearsAgo = calendar.date(byAdding: .year, value: -13, to: Date()) ?? Date()
        return registrationData.dateOfBirth <= thirteenYearsAgo
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
                        Text("What's your date of birth?")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        Spacer().frame(height: 30)
                        
                        // Date input field
                        VStack(alignment: .leading, spacing: 8) {
                            Button(action: {
                                showDatePicker = true
                            }) {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.primaryText35)
                                        .frame(height: 56)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    !isValidAge ? Color.red : Color.clear,
                                                    lineWidth: 1
                                                )
                                        )
                                    
                                    HStack {
                                        Text(dateFormatter.string(from: registrationData.dateOfBirth))
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .padding(.horizontal)
                                        
                                        Spacer()
                                        
                                        // Validation indicator
                                        Image(systemName: isValidAge ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .foregroundColor(isValidAge ? .green : .red)
                                            .padding(.trailing)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            // Error message or helper text
                            VStack(alignment: .leading, spacing: 4) {
                                if !isValidAge {
                                    Text("You must be at least 13 years old to create an account")
                                        .font(.system(size: 14))
                                        .foregroundColor(.red)
                                        .padding(.horizontal)
                                } else {
                                    Text("This won't be shown on your profile.")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.horizontal)
                                }
                            }
                        }
                        
                        Spacer().frame(height: 40)
                        
                        // Next button
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                print("Date of birth button tapped - Valid age: \(isValidAge)")
                                print("Selected date: \(dateFormatter.string(from: registrationData.dateOfBirth))")
                                
                                if isValidAge {
                                    showGenderView = true
                                    print("Navigating to gender view")
                                }
                            }) {
                                Text("Next")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(width: 200, height: 56)
                                    .background(
                                        isValidAge ? Color.white : Color.primaryText80
                                    )
                                    .cornerRadius(28)
                            }
                            .disabled(!isValidAge)
                            .opacity(isValidAge ? 1.0 : 0.6)
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(selectedDate: $registrationData.dateOfBirth, showDatePicker: $showDatePicker)
        }
        .navigationDestination(isPresented: $showGenderView) {
            GenderRegView(registrationData: registrationData)
        }
    }
}
