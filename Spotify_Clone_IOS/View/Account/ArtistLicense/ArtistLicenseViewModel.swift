//
//  AccountViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 15.09.2025.
//
import Foundation
import SwiftUI

@MainActor
final class ArtistLicenseViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var licenses: [License] = []
    @Published var searchText = ""
    @Published var isLoading = false
    
    private let networkManager = NetworkManager.shared
    
    var filteredLicenses: [License] {
        var result = licenses
        
        // Apply search
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.text.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    func getLicenses() {
        isLoading = true
    
        Task {
            do {
                let fetchedLicenses = try await networkManager.getLicenses()
                licenses = fetchedLicenses
                isLoading = false
                
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func deleteLicense(id: Int) {
        isLoading = true
    
        Task {
            do {
                try await networkManager.deleteLicenseById(id: String(id))
                getLicenses()
                isLoading = false
                
            } catch {
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
