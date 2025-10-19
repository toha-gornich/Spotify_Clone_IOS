    //
//  CreateTrackViewModel.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.09.2025.
//


import SwiftUI
import Combine

@MainActor
final class EditLicenseViewModel: ObservableObject {
    
    @Published var licenseName: String = ""
    @Published var licenseText: String = ""
    @Published var license: License = License.empty()
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccessAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var alertItem: AlertItem?
    
    private var cancellables = Set<AnyCancellable>()
    private let licenseManager: LicenseServiceProtocol
    init(licenseManager:LicenseServiceProtocol = NetworkManager.shared) {
        self.licenseManager = licenseManager
    }
    
    
    var canUpdateLicense: Bool {
        let hasNameChange = licenseName != license.name
        let hasTextChange = licenseText != license.text
        
        let isValid = validateLicenseName() == nil && validateLicenseText() == nil
        
        return (hasNameChange || hasTextChange) && isValid && !isLoading
    }
    
    
    func getLicenseById(id: String) {
        isLoading = true
        
        Task {
            do {
                license = try await licenseManager.getLicenseById(id: id)
                populateFormWithLicense()
                isLoading = false
            } catch {
                handleError(error)
                isLoading = false
            }
        }
    }
    
    func populateFormWithLicense() {
        licenseName = license.name
        licenseText = license.text
    }
    
    func editLicense(completion: @escaping (Bool) -> Void) {
        guard canUpdateLicense else {
            return
        }
        
        isLoading = true
        
        Task {
            do {
                _ = try await licenseManager.patchLicenseById(
                    id: String(license.id),
                    name: licenseName != license.name ? licenseName : nil,
                    text: licenseText != license.text ? licenseText : nil
                )
                
                
                    isLoading = false
                    showSuccessAlert = true
                    completion(true)
                
            } catch {
                    isLoading = false
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                    completion(false)
            }
        }
    }
    
    func resetForm() {
        licenseName = ""
        licenseText = ""
    }
    
    func validateLicenseName() -> String? {
        let trimmed = licenseName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return "License name is required"
        }
        if trimmed.count < 2 {
            return "License name must be at least 2 characters"
        }
        if trimmed.count > 100 {
            return "License name must be less than 100 characters"
        }
        return nil
    }
    
    func validateLicenseText() -> String? {
        let trimmed = licenseText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return "License text is required"
        }
        if trimmed.count < 10 {
            return "License text must be at least 10 characters"
        }
        if trimmed.count > 1000 {
            return "License text must be less than 1000 characters"
        }
        return nil
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
