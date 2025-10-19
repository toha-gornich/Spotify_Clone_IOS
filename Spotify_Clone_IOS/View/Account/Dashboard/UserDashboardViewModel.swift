//
//  ProfileView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 15.09.2025.
//

import SwiftUI

@MainActor final class UserDashboardViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var user = UserMe.empty()
    @Published var actor = ""
    
    
    private let userService: UserServiceProtocol
    
    init( userService: UserServiceProtocol = NetworkManager.shared){
        self.userService = userService
    }

    @Published var isLoading = false
    
    
    var isActor: Bool{
        if actor == "User"{
            return true
        }
        return false
    }

    
    
    func getUserMe() async {
        isLoading = true

        do {
            let fetchedUser = try await userService.getUserMe()
            
            await MainActor.run {
                user = fetchedUser
                actor = user.typeProfile!
                print(isActor)
                isLoading = false
            }
            
        } catch {
            await MainActor.run {
                handleError(error)
                isLoading = false
            }
        }
    }

    
    private func handleError(_ error: Error) {
        if let appError = error as? APError {
            switch appError {
            case .invalidResponse:
                alertItem = AlertContext.invalidResponse
            case .invalidURL:
                alertItem = AlertContext.invalidURL
            case .invalidData:
                alertItem = AlertContext.invalidData
            case .unableToComplete:
                alertItem = AlertContext.unableToComplete
            }
        } else {
            alertItem = AlertContext.invalidResponse
        }
    }
}

