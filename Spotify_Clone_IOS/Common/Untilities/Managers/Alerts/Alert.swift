//
//  Alert.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import SwiftUI



struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    //MARK: - Network Alerts
    static let invalidData       = AlertItem(title:Text( "Server Error"),
                                              message:Text( "The data received from the server is invalid. Please contact support."),
                                              dismissButton: .default(Text("OK")))
    
    static let invalidResponse   = AlertItem(title:Text( "Server Error"),
                                             message:Text( "Invalid response from the server. Please contact support."),
                                             dismissButton: .default(Text("OK")))
    
    static let invalidURL        = AlertItem(title:Text( "Server Error"),
                                             message:Text( "There was an issue connecting to the server. If this persist, please contact support."),
                                             dismissButton: .default(Text("OK")))
    
    static let unableToComplete = AlertItem(title:Text( "Server Error"),
                                             message:Text( "Unable to complete your request at this time. Please check your internet connection."),
                                             dismissButton: .default(Text("OK")))
    
    //MARK: - Network Alerts
    
    static let invalidForm      = AlertItem(title:Text( "Invalid Form"),
                                             message:Text( "Please ensure all fields in the form have been filled out"),
                                             dismissButton: .default(Text("OK")))
    static let invalidEmail     = AlertItem(title:Text( "Invalid Email"),
                                             message:Text( "Please ensure your email is correct."),
                                             dismissButton: .default(Text("OK")))
    static let userSaveSuccess  = AlertItem(title:Text( "Profile Saved"),
                                             message:Text( "Your profile information was successfully saved."),
                                             dismissButton: .default(Text("OK")))
    static let invalidUserData  = AlertItem(title:Text( "Profiler Error"),
                                             message:Text( "There was an error saving or retriving your profile."),
                                             dismissButton: .default(Text("OK")))
}
