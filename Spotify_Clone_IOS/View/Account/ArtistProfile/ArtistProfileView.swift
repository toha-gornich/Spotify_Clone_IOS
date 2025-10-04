//
//  ArtistProfileView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 28.09.2025.
//

import SwiftUI

struct ArtistProfileView: View {
    @StateObject private var artistVM = ArtistProfileViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    HStack {
                        Text("This is how others will see you on the site.")
                            .font(.body)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 20) {
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            artistVM.showImagePicker = true
                        }) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 200, height: 200)
                                .overlay(
                                    Group {
                                        if let selectedImage = artistVM.selectedImage {
                                            Image(uiImage: selectedImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 200, height: 200)
                                                .clipShape(Circle())
                                        } else {
                                            SpotifyRemoteImage(urlString: artistVM.artist.image)
                                                .frame(width: 200, height: 200)
                                                .clipShape(Circle())
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
                    .sheet(isPresented: $artistVM.showImagePicker) {
                        ImagePicker(selectedImage: $artistVM.selectedImage)
                    }
                    
                    
                    // Display Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("First Name")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        TextField("", text: $artistVM.firstName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    .background(Color.clear)
                            )
                            .foregroundColor(.white)
                    }
                    
                    // Display Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Last Name")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        TextField("", text: $artistVM.lastName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    .background(Color.clear)
                            )
                            .foregroundColor(.white)
                    }
                    
                    // Display Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Display Name")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        TextField("", text: $artistVM.displayName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    .background(Color.clear)
                            )
                            .foregroundColor(.white)
                    }
         
                    // Update Profile Button
                    Button(action: {
                        artistVM.updateProfile()
                    }) {
                        HStack {
                            if artistVM.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.black)
                            }
                            
                            Text("Update artist profile")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            artistVM.canUpdateProfile ?
                            Color.green :
                            Color.green.opacity(0.5)
                        )
                        .cornerRadius(8)
                        .scaleEffect(artistVM.canUpdateProfile ? 1.0 : 0.95)
                        .opacity(artistVM.canUpdateProfile ? 1.0 : 0.6)
                    }
                    .disabled(!artistVM.canUpdateProfile || artistVM.isLoading)
                    .padding(.top, 10)

                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .onAppear() {
                artistVM.getArtistMe()
                artistVM.loadUserData()
            }
        }
        .background(Color.bg)
    }
}
