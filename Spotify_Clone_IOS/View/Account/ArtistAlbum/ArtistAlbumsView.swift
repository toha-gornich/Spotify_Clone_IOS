//
//  ArtistAlbumsView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 28.09.2025.
//

import SwiftUI

struct ArtistAlbumsView: View {
    @StateObject private var albumsVM = ArtistAlbumsViewModel()
    @State private var selectedAlbumId: String? = nil
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
                                Text("Artist albums")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            Text("Create and update your albums.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Filter and Search Section
                        VStack(spacing: 16) {
                            // Filter tabs
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(ArtistAlbumsViewModel.AlbumFilter.allCases, id: \.self) { filter in
                                        Button(action: {
                                            albumsVM.selectedFilter = filter
                                        }) {
                                            Text(filter.title)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(albumsVM.selectedFilter == filter ? .white : .gray)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(albumsVM.selectedFilter == filter ? Color.gray.opacity(0.3) : Color.clear)
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
                                    
                                    TextField("Search...", text: $albumsVM.searchText)
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
                                        albumsVM.searchAlbums()
                                    }
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    
//                                    
                                    
                                    Spacer()
                                    
                                    // Add Album button
                                    Button(action: {
                                        albumsVM.showCreateAlbum = true
                                    }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "plus")
                                            Text("Add Album")
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
                        
                        // Albums Content Section
                        VStack(spacing: 0) {
                            // Albums header
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Albums")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    if showOnlyPrivate {
                                        Text("(Private)")
                                            .font(.subheadline)
                                            .foregroundColor(.green)
                                    }
                                }
                                
                                Text("Manage your Albums and view their details.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                            
                            // Albums list
                            VStack(spacing: 1) {
                                ForEach(albumsVM.filteredAlbums, id: \.id) { album in
                                    VStack(spacing: 8) {
                                        HStack {
                                            // Cover
                                            SpotifyRemoteImage(urlString: album.image!)
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 50, height: 50)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                // Title with privacy indicator
                                                HStack(spacing: 6) {
                                                    Text(album.title)
                                                        .font(.system(size: 16, weight: .medium))
                                                        .foregroundColor(.white)
                                                        .lineLimit(1)
                                                    
                                                    if album.isPrivate {
                                                        Image(systemName: "lock.fill")
                                                            .font(.system(size: 10))
                                                            .foregroundColor(.gray)
                                                    }
                                                }
                                                
                                                HStack {
                                                    Text(album.formattedReleaseDate)
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                    
                                                    Text("•")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                    
                                                    Text("\(album.formattedListenersCount)")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                    
                                                    Text("•")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                    
                                                    Text(String(album.tracksCount) + " tracks")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.green)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            // Menu button with dropdown
                                            Menu {
                                                Button(action: {
                                                    slug = album.slug
                                                    albumsVM.showEditAlbum = true
                                                    print("Edit album: \(album.id)")
                                                }) {
                                                    Label("Edit", systemImage: "pencil")
                                                }
                                                
                                                Button(action: {
                                                    albumsVM.togglePrivacy(album: album)
                                                }) {
                                                    Label(album.isPrivate ? "Make public" : "Make private",
                                                          systemImage: album.isPrivate ? "eye" : "eye.slash")
                                                }
                                                
                                                Divider()
                                                
                                                Button(role: .destructive, action: {
                                                    albumsVM.deleteAlbum(slug: album.slug)
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
            albumsVM.getAlbumsMy()
            albumsVM.loadAlbumsData()
        }
        .sheet(isPresented: $albumsVM.showCreateAlbum) {
            NavigationStack {
                CreateAlbumView()
            }
        }
        .sheet(isPresented: $albumsVM.showEditAlbum) {
            NavigationStack {
                EditAlbumView(slug: slug)
            }
        }
    }
}
