//
//  AppViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 27.02.2026.
//

import Foundation

@MainActor
final class AppViewModel: ObservableObject{
    @Published var appState: AppState = .loading
    
    enum AppState {
        case loading
        case authenticated
        case unauthenticated
    }
    
    private let networkManager = NetworkManager.shared
    
    
}
