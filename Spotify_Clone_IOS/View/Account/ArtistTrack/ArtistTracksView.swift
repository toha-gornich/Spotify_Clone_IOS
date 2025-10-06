//
//  ArtistTracksView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 28.09.2025.
//

import SwiftUI

struct ArtistTracksView: View {
    @StateObject private var tracksVM = ArtistTracksViewModel()
    @State private var selectedTrackId: String? = nil
    @State private var slug: String = ""
    @State private var showOnlyPrivate = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.bg.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Artist tracks")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            Text("Create update your tracks.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Filter and Search Section
                        VStack(spacing: 16) {
                            // Filter tabs
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(ArtistTracksViewModel.TrackFilter.allCases, id: \.self) { filter in
                                        Button(action: {
                                            tracksVM.selectedFilter = filter
                                        }) {
                                            Text(filter.title)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(tracksVM.selectedFilter == filter ? .white : .gray)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(tracksVM.selectedFilter == filter ? Color.gray.opacity(0.3) : Color.clear)
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Search and buttons
                            VStack(spacing: 12) {
                                // Search field
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 16))
                                    
                                    TextField("Search...", text: $tracksVM.searchText)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                
                                // Buttons row
                                HStack(spacing: 8) {
                                    // Search button
                                    Button("Search") {
                                        tracksVM.searchTracks()
                                    }
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    
                                    // Private filter button
                                    Button(action: {
                                        showOnlyPrivate.toggle()
                                        tracksVM.filterPrivateTracks(showOnlyPrivate)
                                    }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: showOnlyPrivate ? "eye.slash.fill" : "eye.fill")
                                            Text(showOnlyPrivate ? "Private" : "All")
                                        }
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(showOnlyPrivate ? Color.green.opacity(0.3) : Color.clear)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                    
                                    Spacer()
                                    
                                    // Add Track button
                                    Button(action: {
                                        tracksVM.showCreateTrack = true
                                    }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "plus")
                                            Text("Add Track")
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
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Tracks Content Section
                        VStack(spacing: 0) {
                            // Tracks header
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Tracks")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    if showOnlyPrivate {
                                        Text("(Private)")
                                            .font(.subheadline)
                                            .foregroundColor(.green)
                                    }
                                }
                                
                                Text("Manage your Tracks and view their details.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                            
                            // Tracks list
                            VStack(spacing: 1) {
                                ForEach(tracksVM.filteredTracks, id: \.id) { track in
                                    VStack(spacing: 8) {
                                        HStack {
                                            // Cover
                                            SpotifyRemoteImage(urlString: track.album.image)
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 50, height: 50)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                // Title with privacy indicator
                                                HStack(spacing: 6) {
                                                    Text(track.title)
                                                        .font(.system(size: 16, weight: .medium))
                                                        .foregroundColor(.white)
                                                        .lineLimit(1)
                                                    
                                                    if track.isPrivate {
                                                        Image(systemName: "lock.fill")
                                                            .font(.system(size: 10))
                                                            .foregroundColor(.gray)
                                                    }
                                                }
                                                
                                                HStack {
                                                    Text(track.albumTitle)
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                    
                                                    Text("•")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                    
                                                    Text(track.genreName)
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                    
                                                    Text("•")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                    
                                                    Text(track.formattedPlaysCount)
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.green)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            // Menu button with dropdown
                                            Menu {
                                                Button(action: {
                                                    slug = track.slug
                                                    tracksVM.showEditTrack = true
                                                    print("Edit track: \(track.id)")
                                                }) {
                                                    Label("Edit", systemImage: "pencil")
                                                }
                                                
                                                Button(action: {
                                                    tracksVM.togglePrivacy(track: track)
                                                }) {
                                                    Label(track.isPrivate ? "Make public" : "Make private",
                                                          systemImage: track.isPrivate ? "eye" : "eye.slash")
                                                }
                                                
                                                Divider()
                                                
                                                Button(role: .destructive, action: {
                                                    tracksVM.deleteTrack(slug: track.slug)
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
                                    .padding(.vertical, 12)
                                    .background(Color.bg)
                                    .overlay(
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 0.5),
                                        alignment: .bottom
                                    )
                                }
                            }
                            
                            // Pagination
                            HStack {
                                Button(action: {}) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "chevron.left")
                                        Text("Previous")
                                    }
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    HStack(spacing: 6) {
                                        Text("Next")
                                        Image(systemName: "chevron.right")
                                    }
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
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
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .onAppear() {
            tracksVM.getTracksMy()
            tracksVM.loadTracksData()
        }
        .sheet(isPresented: $tracksVM.showCreateTrack) {
            NavigationStack {
                CreateTrackView()
            }
        }
        .sheet(isPresented: $tracksVM.showEditTrack) {
            NavigationStack {
                EditTrackView(slug:slug)
            }
        }
    }
}
