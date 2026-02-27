//
//  ProfileView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 15.09.2025.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    var userId: String? = nil
    @StateObject private var profileVM = ProfileViewModel()
    @EnvironmentObject var playerManager: AudioPlayerManager
    @EnvironmentObject var router: Router
    @State private var selectedPlaylistSlug: String?
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView {
                
                HStack{
                    BackButton()
                        .padding(.leading, 16)
                        .padding(.top, 16)
                    Spacer()
                }
                
                VStack(spacing: 24) {
                    HStack(spacing: 16) {
                        
                        SpotifyRemoteImage(urlString: profileVM.image)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        
                        // User info
                        VStack(alignment: .leading, spacing: 8) {
                            Text(profileVM.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack{
                                    Text("\(profileVM.playlistsCount)")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text("Public Playlists")
                                        .foregroundColor(.gray)
                                }
                                
                                HStack{
                                    Text("\(profileVM.followersCount)")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text("followers")
                                        .foregroundColor(.gray)
                                    
                                    Text("•")
                                        .foregroundColor(.gray)
                                    
                                    Text("\(profileVM.followingCount)")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    Text("following")
                                        .foregroundColor(.gray)
                                }
                            }
                            .font(.subheadline)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        Button(action: {
                            profileVM.followUser()
                        }) {
                            Text("Follow")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            profileVM.shareProfile()
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                        }
                        
                        Button(action: {
                            profileVM.showMoreOptions()
                        }) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .font(.title2)
                                .frame(width: 44, height: 44)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    
                    // Playlists section
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Followers")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                            
                            if profileVM.isLoading && profileVM.followers.isEmpty {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(height: 100)
                            } else if profileVM.followers.isEmpty {
                                Text("No followers yet")
                                    .foregroundColor(.gray)
                                    .frame(height: 100)
                                    .frame(maxWidth: .infinity)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 15) {
                                        ForEach(profileVM.followers) { user in
                                            Button(){
                                                router.navigateTo(AppRoute.profile(profileId: String(user.id)))
                                            }label: {
                                                ArtistItemView(user: user)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Following")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                            
                            if profileVM.isLoading && profileVM.following.isEmpty {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(height: 100)
                            } else if profileVM.following.isEmpty {
                                Text("No following yet")
                                    .foregroundColor(.gray)
                                    .frame(height: 100)
                                    .frame(maxWidth: .infinity)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 15) {
                                        ForEach(profileVM.following) { user in
                                            Button(){
                                                router.navigateTo(AppRoute.profile(profileId: String(user.id)))
                                            }label: {
                                                ArtistItemView(user: user)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }

                        
                        // See all playlists button
                        if(profileVM.playlists.count>3){
                            Button(action: {
                                profileVM.showAllPlaylists()
                            }) {
                                Text("See all playlists")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .background(Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 16)
                            .padding(.bottom, 100)
                        }
                        
                    }
                }
            }
            .scrollDisabled(true)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [profileVM.themeColor, Color.bg]),
                    startPoint: .top,
                    endPoint: UnitPoint(x: 0.5, y: 0.35)
                )
            )
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [profileVM.themeColor.opacity(0.8), Color.bg]),
                startPoint: .top,
                endPoint: UnitPoint(x: 0.5, y: 0.35)
            )
            .ignoresSafeArea()
        )
        .navigationBarHidden(true)
        .swipeBack(router: router)
        .onAppear {
            Task {
                await profileVM.getUserMe(userId: userId)
                await profileVM.loadPlaylists()
            }
        }
    }
}

#Preview {
    NavigationView{
        ProfileView()
    }
}
