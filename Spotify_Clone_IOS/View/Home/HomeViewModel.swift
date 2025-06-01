//
//  HomeViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 01.06.2025.
//

import SwiftUI

@MainActor final class HomeViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var artists: [Artist] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectTab: Int = 0
    @Published var alertItem: AlertItem?
    
    private let networkManager = NetworkManager.shared
    
    
    func getTracks() {
        isLoading = true
        
        Task{
            do{
                tracks = try await NetworkManager.shared.getTracks()
                isLoading = false
                
            }catch{
                if let apError = error as? APError{
                    switch apError{
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidResponse
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                    case .invalidData:
                        self.alertItem = AlertContext.invalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }else{
                    alertItem = AlertContext.invalidResponse
                }
                
                isLoading = false
            }
        }
    }
    
    func getArtists() {
        isLoading = true
        
        Task{
            do{
                artists = try await NetworkManager.shared.getArtists()
                isLoading = false
                
            }catch{
                if let apError = error as? APError{
                    switch apError{
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidResponse
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                    case .invalidData:
                        self.alertItem = AlertContext.invalidData
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }else{
                    alertItem = AlertContext.invalidResponse
                }
                
                isLoading = false
            }
        }
    }
}
