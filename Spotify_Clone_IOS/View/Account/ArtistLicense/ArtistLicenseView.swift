//
//  ArtistAlbumsView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 28.09.2025.
//

import SwiftUI

struct ArtistLicenseView: View {
    @StateObject private var licenseVM = ArtistLicenseViewModel()
    @State private var selectedLicenseId: Int? = nil
    @State private var showOnlyPrivate = false
    @State private var showCreateLicense = false
    @State private var showEditLicense = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.bg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Licenses")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            Text("View and manage your licenses.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Filter and Search Section
                        VStack(spacing: 16) {
                            // Search and Add button
                            HStack(spacing: 12) {
                                // Search field
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                    
                                    TextField("Search...", text: $licenseVM.searchText)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                
                                // Add License button
                                Button(action: {
                                    showCreateLicense = true
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "plus")
                                        Text("Add")
                                    }
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.green)
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Licenses Content Section
                        VStack(spacing: 0) {
                            // Licenses header
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Available Licenses")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("View license names and descriptions.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                            
                            // Licenses list
                            VStack(spacing: 1) {
                                ForEach(licenseVM.filteredLicenses, id: \.id) { license in
                                    VStack(spacing: 8) {
                                        HStack(alignment: .top, spacing: 12) {
                                            VStack(alignment: .leading, spacing: 6) {
                                                // License name
                                                Text(license.name)
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundColor(.white)
                                                    .lineLimit(2)
                                                
                                                // License description
                                                Text(license.text)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.gray)
                                                    .lineLimit(3)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            
                                            Spacer()
                                            
                                            // Menu button with dropdown
                                            Menu {
                                                Button(action: {
                                                    selectedLicenseId = license.id
                                                    print(String(selectedLicenseId!))
                                                    showEditLicense = true
                                                }) {
                                                    Label("Edit", systemImage: "pencil")
                                                }
                                                
                                                Divider()
                                                
                                                Button(role: .destructive, action: {
                                                    licenseVM.deleteLicense(id: license.id)
                                                }) {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            } label: {
                                                Image(systemName: "ellipsis")
                                                    .foregroundColor(.gray)
                                                    .font(.system(size: 16))
                                                    .frame(width: 32, height: 32)
                                                    .contentShape(Rectangle())
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(Color.bg)
                                    .overlay(
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 0.5),
                                        alignment: .bottom
                                    )
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.bg)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 20)
                    }
                }
                
                if licenseVM.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .onAppear() {
            licenseVM.getLicenses()
        }
        .sheet(isPresented: $showCreateLicense) {
            NavigationStack {
                CreateLicenseView()
            }
        }
        .sheet(item: $selectedLicenseId) { licenseId in
            NavigationStack {
                EditLicenseView(slug: String(licenseId))
            }
        }
    }
}

extension Int: @retroactive Identifiable {
    public var id: Int { self }
}
