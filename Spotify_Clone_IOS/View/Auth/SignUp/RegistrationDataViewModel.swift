//
//  RegistrationDataViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 05.08.2025.
//

import SwiftUI

class RegistrationData: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var username: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var gender: String = ""
    @Published var country: String = ""
    @Published var marketingConsent: Bool = false
    
    // Validation
    var isEmailValid: Bool {
        email.contains("@") && email.contains(".")
    }
    
    var isPasswordValid: Bool {
        password.count >= 8
    }
    
    var doPasswordsMatch: Bool {
        password == confirmPassword
    }
    
    var isUsernameValid: Bool {
        username.count >= 3
    }
    
    // Convert to dictionary for POST request
    func toDictionary() -> [String: Any] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return [
            "email": email,
            "password": password,
            "username": username,
            "date_of_birth": formatter.string(from: dateOfBirth),
            "gender": gender,
            "country": country,
            "marketing_consent": marketingConsent
        ]
    }
    
    // POST request function
    func registerUser(){

    }
}
