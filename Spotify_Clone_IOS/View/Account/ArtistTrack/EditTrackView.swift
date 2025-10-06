//
//  CreateTrackView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.09.2025.
//
import SwiftUI
import PhotosUI

struct EditTrackView: View {
    @StateObject private var trackVM = EditTrackViewModel()
    @Environment(\.dismiss) var dismiss
    var slug : String
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Edit Track")
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
                            trackVM.showImagePicker = true
                        }) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 200, height: 200)
                                .overlay(
                                    Group {
                                        if let selectedImage = trackVM.selectedImage {
                                            Image(uiImage: selectedImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 200, height: 200)
                                                .clipShape(Circle())
                                        } else {
                                            imagePlaceholder
                                        }
                                    }
                                )
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                        .padding(8)
                                    , alignment: .bottomTrailing
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.top, 20)
                    .sheet(isPresented: $trackVM.showImagePicker) {
                        ImagePicker(selectedImage: $trackVM.selectedImage)
                    }
                    
                    VStack(spacing: 20) {
                        // Track Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Track title")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            TextField("My track...", text: $trackVM.trackTitle)
                                .textFieldStyle(CustomTextFieldStyle())
                            
                            if let error = trackVM.validateTrackTitle() {
                                Text(error)
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                            }
                        }
                        
                        // Album Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Album")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            CustomDropdown(
                                selectedItem: trackVM.selectedAlbum?.title,
                                placeholder: "Select your album",
                                items: trackVM.albums.map { $0.title },
                                onSelect: { index in
                                    trackVM.selectedAlbum = trackVM.albums[index]
                                }
                            )
                        }
                        
                        // Genre Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Genre")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            CustomDropdown(
                                selectedItem: trackVM.selectedGenre?.name,
                                placeholder: "Select your genre",
                                items: trackVM.genres.map { $0.name },
                                onSelect: { index in
                                    trackVM.selectedGenre = trackVM.genres[index]
                                }
                            )
                        }
                        
                        // License Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("License")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            CustomDropdown(
                                selectedItem: trackVM.selectedLicense?.name,
                                placeholder: "Select your license",
                                items: trackVM.licenses.map { $0.name },
                                onSelect: { index in
                                    trackVM.selectedLicense = trackVM.licenses[index]
                                }
                            )
                        }
                        
                        // Audio File Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Button(action: {
                                trackVM.showAudioPicker = true
                            }) {
                                HStack {
                                    Text(trackVM.audioFileName)
                                        .foregroundColor(trackVM.selectedAudioFile == nil ? .gray : .white)
                                        .lineLimit(1)
                                    Spacer()
                                    Image(systemName: "waveform")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        
                        // Release Date
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Release date")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            DatePicker(
                                "",
                                selection: $trackVM.releaseDate,
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
                            
                            Text("Date when track released.")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        // Is Private Toggle
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Toggle("", isOn: $trackVM.isPrivate)
                                    .labelsHidden()
                                    .tint(.green)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Is private?")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Text("If true only you can see your track")
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
                    
                    // edit Button
                    Button(action: {
                        trackVM.editTrack { success in
                            if success {
                                dismiss()
                            }
                        }
                    }) {
                        if trackVM.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .bg))
                        } else {
                            Text("Edit track")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.bg)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(trackVM.canUpdateTrack ? Color.green : Color.gray.opacity(0.3))
                    )
                    .disabled(!trackVM.canUpdateTrack || trackVM.isLoading)
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
                        Text("Tracks")
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear{trackVM.getTrackBySlug(slug: slug)}
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.bg, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .alert("Success", isPresented: $trackVM.showSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Edit track successfully!")
        }
        .alert("Error", isPresented: $trackVM.showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(trackVM.errorMessage ?? "Unknown error occurred")
        }
        .sheet(isPresented: $trackVM.showAudioPicker) {
            DocumentPicker(selectedFile: $trackVM.selectedAudioFile)
        }
        .sheet(isPresented: $trackVM.showImagePicker) {
            DocumentPicker(selectedFile: $trackVM.selectedImageFile)
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




