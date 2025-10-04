//
//  CreateTrackView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 30.09.2025.
//
import SwiftUI
import PhotosUI

struct CreateTrackView: View {
    @StateObject private var trackVM = CreateTrackViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Create Track")
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
                    
                    // Create Button
                    Button(action: {
                        trackVM.createTrack { success in
                            if success {
                                dismiss()
                            }
                        }
                    }) {
                        if trackVM.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .bg))
                        } else {
                            Text("Create track")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.bg)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(trackVM.isFormValid ? Color.green : Color.gray.opacity(0.3))
                    )
                    .disabled(!trackVM.isFormValid || trackVM.isLoading)
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
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.bg, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        
        .alert("Success", isPresented: $trackVM.showSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Track created successfully!")
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

// MARK: - Custom Dropdown
struct CustomDropdown: View {
    let selectedItem: String?
    let placeholder: String
    let items: [String]
    let onSelect: (Int) -> Void
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedItem ?? placeholder)
                        .foregroundColor(selectedItem == nil ? .gray : .white)
                        .font(.system(size: 16))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: isExpanded ? 8 : 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.2))
                        )
                )
            }
            
            // Dropdown List
            if isExpanded {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                                Button(action: {
                                    onSelect(index)
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isExpanded = false
                                    }
                                }) {
                                    HStack {
                                        Text(item)
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                        Spacer()
                                        if selectedItem == item {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.green)
                                                .font(.system(size: 14, weight: .semibold))
                                        }
                                    }
                                    .padding()
                                    .background(
                                        selectedItem == item
                                        ? Color.gray.opacity(0.2)
                                        : Color.clear
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if index < items.count - 1 {
                                    Divider()
                                        .background(Color.gray.opacity(0.2))
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.bg.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.top, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .zIndex(isExpanded ? 1 : 0)
    }
}

// MARK: - Custom TextField Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.clear)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

// MARK: - Document Picker
struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedFile: URL?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio, .image])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            parent.selectedFile = url
            parent.dismiss()
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        CreateTrackView()
    }
}
