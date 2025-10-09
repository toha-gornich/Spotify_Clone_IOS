//
//  CreateTrackView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.09.2025.
//
import SwiftUI
import PhotosUI


struct CreateAlbumView: View {
    @StateObject private var albumVM = CreateAlbumViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Create Album")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Image Upload Section
                    VStack(spacing: 16) {
                        Button(action: {
                            albumVM.showImagePicker = true
                        }) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 200, height: 200)
                                .overlay(
                                    Group {
                                        if let selectedImage = albumVM.selectedImage {
                                            Image(uiImage: selectedImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 200, height: 200)
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                        } else {
                                            imagePlaceholder
                                        }
                                    }
                                )
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(12)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                        .padding(8)
                                    , alignment: .bottomTrailing
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.top, 20)
                    .sheet(isPresented: $albumVM.showImagePicker) {
                        ImagePicker(selectedImage: $albumVM.selectedImage)
                    }
                    
                    VStack(spacing: 20) {
                        // Album Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Album title")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            TextField("My album...", text: $albumVM.albumTitle)
                                .textFieldStyle(CustomTextFieldStyle())
                            
                            if let error = albumVM.validateAlbumTitle() {
                                Text(error)
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            TextEditor(text: $albumVM.albumDescription)
                                .frame(minHeight: 100)
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
                                if let error = albumVM.validateDescription() {
                                    Text(error)
                                        .font(.system(size: 12))
                                        .foregroundColor(.red)
                                }
                                Spacer()
                                Text("\(albumVM.albumDescription.count)/500")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }

                        
                        // Release Date
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Release date")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            DatePicker(
                                "",
                                selection: $albumVM.releaseDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                            .colorScheme(.dark)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.black.opacity(0.2))
                                    )
                            )
                            
                            Text("Date when album was released")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        // Is Private Toggle
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Toggle("", isOn: $albumVM.isPrivate)
                                    .labelsHidden()
                                    .tint(.green)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Is private?")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Text("If enabled, only you can see this album")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Create Button
                    Button(action: {
                        albumVM.createAlbum { success in
                            if success {
                                dismiss()
                            }
                        }
                    }) {
                        if albumVM.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .bg))
                        } else {
                            Text("Create album")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.bg)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(albumVM.isFormValid ? Color.green : Color.gray.opacity(0.3))
                    )
                    .disabled(!albumVM.isFormValid || albumVM.isLoading)
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
                        Text("Albums")
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.bg, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .alert("Success", isPresented: $albumVM.showSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Album created successfully!")
        }
        .alert("Error", isPresented: $albumVM.showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(albumVM.errorMessage ?? "Unknown error occurred")
        }
    }
    
    private var imagePlaceholder: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 200, height: 200)
            .overlay(
                Image(systemName: "photo.badge.plus")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
            )
    }
}

#Preview {
    NavigationStack {
        CreateAlbumView()
    }
}
