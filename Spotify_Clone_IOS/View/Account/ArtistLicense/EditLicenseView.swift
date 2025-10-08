//
//  CreateTrackView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.09.2025.
//
import SwiftUI
import SwiftUI

struct EditLicenseView: View {
    @StateObject private var licenseVM = EditLicenseViewModel()
    @Environment(\.dismiss) var dismiss
    var slug: String
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Edit License")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        // License Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("License name")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            TextField("My license...", text: $licenseVM.licenseName)
                                .textFieldStyle(CustomTextFieldStyle())
                            
                            if let error = licenseVM.validateLicenseName() {
                                Text(error)
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // License Text/Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("License text")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            TextEditor(text: $licenseVM.licenseText)
                                .frame(minHeight: 150)
                                .padding(12)
                                .background(Color.black.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .scrollContentBackground(.hidden)
                            
                            HStack {
                                if let error = licenseVM.validateLicenseText() {
                                    Text(error)
                                        .font(.system(size: 12))
                                        .foregroundColor(.red)
                                }
                                Spacer()
                                Text("\(licenseVM.licenseText.count)/1000")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Update Button
                    Button(action: {
                        licenseVM.editLicense { success in
                            if success {
                                dismiss()
                            }
                        }
                    }) {
                        if licenseVM.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .bg))
                        } else {
                            Text("Update license")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.bg)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(licenseVM.canUpdateLicense ? Color.green : Color.gray.opacity(0.3))
                    )
                    .disabled(!licenseVM.canUpdateLicense || licenseVM.isLoading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Licenses")
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            licenseVM.getLicenseById(id: slug)
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.bg, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .alert("Success", isPresented: $licenseVM.showSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("License updated successfully!")
        }
        .alert("Error", isPresented: $licenseVM.showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(licenseVM.errorMessage ?? "Unknown error occurred")
        }
    }
}
