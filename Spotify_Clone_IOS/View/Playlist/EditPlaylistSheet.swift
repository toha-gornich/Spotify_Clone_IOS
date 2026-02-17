//
//  EditPlaylistSheet.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 16.02.2026.
//


import SwiftUI
import PhotosUI

struct EditPlaylistSheet: View {
    @Environment(\.dismiss) private var dismiss
    let playlist: PlaylistDetail
    let onSave: (String, String, Bool, Data?) -> Void
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var isPrivate: Bool = true
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var previewImage: UIImage?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.bg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Image picker
                        VStack(alignment: .center, spacing: 12) {
                            Text("Playlist Image")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 16) {
                                Spacer()
                                
                                PhotosPicker(selection: $selectedImage, matching: .images) {
                                    ZStack {
                                        if let previewImage = previewImage {
                                            Image(uiImage: previewImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 150, height: 150)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        } else if !playlist.image.isEmpty {
                                            SpotifyRemoteImage(urlString: playlist.image)
                                                .frame(width: 150, height: 150)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        } else {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 150, height: 150)
                                            
                                            VStack(spacing: 8) {
                                                Image(systemName: "photo")
                                                    .font(.system(size: 40))
                                                    .foregroundColor(.white.opacity(0.6))
                                                Text("Tap to change")
                                                    .font(.caption)
                                                    .foregroundColor(.white.opacity(0.6))
                                            }
                                        }
                                        
                                        // Overlay indicator for image picker
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                Image(systemName: "camera.fill")
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .padding(8)
                                                    .background(Color.black.opacity(0.6))
                                                    .clipShape(Circle())
                                                    .padding(8)
                                            }
                                        }
                                        .frame(width: 150, height: 150)
                                    }
                                    .frame(width: 150, height: 150)
                                }
                                .onChange(of: selectedImage) { newValue in
                                    Task {
                                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                            imageData = data
                                            previewImage = UIImage(data: data)
                                        }
                                    }
                                }
                                
                                // Remove image button
                                if previewImage != nil {
                                    Button(action: {
                                        selectedImage = nil
                                        imageData = nil
                                        previewImage = nil
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.red)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        
                        // Title field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Playlist Name")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            TextField("Enter playlist name", text: $title)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                        
                        // Description field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (Optional)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            TextEditor(text: $description)
                                .frame(height: 100)
                                .padding(8)
                                .scrollContentBackground(.hidden)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                        
                        // Privacy Toggle
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Privacy")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 8) {
                                        Image(systemName: isPrivate ? "lock.fill" : "globe")
                                            .foregroundColor(isPrivate ? .yellow : .green)
                                        
                                        Text(isPrivate ? "Private" : "Public")
                                            .font(.body)
                                            .foregroundColor(.white)
                                            .fontWeight(.medium)
                                    }
                                    
                                    Text(isPrivate ? "Only you can see and edit this playlist" : "Anyone can see this playlist")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $isPrivate)
                                    .labelsHidden()
                                    .tint(.green)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Edit Playlist")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(title, description, isPrivate, imageData)
                        dismiss()
                    }
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty)
                }
            }
        }
        .onAppear {
            title = playlist.title
            description = playlist.description ?? ""
            isPrivate = playlist.isPrivate ?? true
        }
    }
}