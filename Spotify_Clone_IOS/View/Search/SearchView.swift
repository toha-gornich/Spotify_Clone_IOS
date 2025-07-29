//
//  SearchView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 28.07.2025.
//

import SwiftUI
struct SearchView: View {
    let searchText: String
    @StateObject private var searchVM = SearchViewModel()
    @State private var currentSearchText: String = ""
    @State private var selectedTab: SearchTab = .all
    @Environment(\.dismiss) private var dismiss
    
    enum SearchTab: String, CaseIterable {
        case all = "All"
        case songs = "Songs"
        case albums = "Albums"
        case artists = "Artists"
        case playlists = "Playlists"
        case profiles = "Profiles"
    }
    
    
    private var availableTabs: [SearchTab] {
        guard !currentSearchText.isEmpty else { return [] }
        
        var tabs: [SearchTab] = []
        
        //Check if there are results for each type
        let hasSongs = !searchVM.tracks.isEmpty
        let hasAlbums = !searchVM.albums.isEmpty
        let hasArtists = !searchVM.artists.isEmpty
        let hasPlaylists = !searchVM.playlists.isEmpty
        let hasProfiles = !searchVM.profiles.isEmpty
        
        //Додаємо "All" тільки якщо є хоча б один тип результатів
        if hasSongs || hasAlbums || hasArtists || hasPlaylists || hasProfiles {
            tabs.append(.all)
        }
        
        
        if hasSongs { tabs.append(.songs) }
        if hasAlbums { tabs.append(.albums) }
        if hasArtists { tabs.append(.artists) }
        if hasPlaylists { tabs.append(.playlists) }
        if hasProfiles { tabs.append(.profiles) }
        
        return tabs
    }
    // Check if the selected tab is still available
    private func validateSelectedTab() {
        if !availableTabs.contains(selectedTab) {
            selectedTab = availableTabs.first ?? .all
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom App Bar
            VStack(spacing: 0) {
                // Search field section
                HStack(spacing: 12) {
                    // Search field with magnifying glass
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 18))
                        
                        TextField("", text: $currentSearchText)
                            .foregroundColor(.white)
                            .font(.customFont(.regular, fontSize: 16))
                            .tint(.white) // Cursor color
                            .placeholder(when: currentSearchText.isEmpty) {
                                Text("What do you want to listen to?")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.customFont(.regular, fontSize: 16))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        
                        // Clear button container
                        HStack {
                            if !currentSearchText.isEmpty {
                                Button(action: {
                                    currentSearchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.white.opacity(1))
                                        .font(.system(size: 18))
                                }
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.clear)
                                    .font(.system(size: 18))
                            }
                        }
                        .frame(width: 18)
                    }
                    .frame(height: 44)
                    .padding(.horizontal, 16)
                    .background(Color.primaryText.opacity(0.2))
                    .cornerRadius(10)
                    
                    // Cancel button
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.white)
                            .font(.customFont(.medium, fontSize: 14))
                    }
                    .fixedSize()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .padding(.top, .topInsets)
                
                // Tabs section
                if !availableTabs.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(availableTabs, id: \.self) { tab in
                                Button(action: {
                                    selectedTab = tab
                                }) {
                                    HStack(spacing: 6) {
                                        Text(tab.rawValue)
                                            .font(.customFont(.medium, fontSize: 14))
                                            .foregroundColor(selectedTab == tab ? .black : .white)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(selectedTab == tab ? Color.green : Color.elementBg)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    .frame(maxWidth: .infinity)
                    .transition(.opacity)
                }
            }
            .background(Color.lightBg)
            
            // Content area
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    if !availableTabs.isEmpty {
                        
                        switch selectedTab {
                        case .all:
                            AllSearchContentView(searchText: currentSearchText, searchVM: searchVM)
                        case .songs:
                            TrackListViewImage(tracks: searchVM.tracks)
                                .padding(.bottom, 70)
                        case .albums:
                            AlbumsSearchContentView(searchText: currentSearchText, searchVM: searchVM)
                        case .artists:
                            ArtistsSearchContentView(searchText: currentSearchText, searchVM: searchVM)
                        case .playlists:
                            PlaylistsSearchContentView(searchText: currentSearchText, searchVM: searchVM)
                        case .profiles:
                            ProfilesSearchContentView(searchText: currentSearchText, searchVM: searchVM)
                        }
                    } else {
                        EmptySearchView()
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .task {
                searchVM.searchTracks(searchText: currentSearchText)
                searchVM.searchArtists(searchText: currentSearchText)
                searchVM.searchAlbums(searchText: currentSearchText)
                searchVM.searchPlaylists(searchText: currentSearchText)
                searchVM.searchProfiles(searchText: currentSearchText)
            }
            .background(Color.bg)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            // Initialize search text from parameter
            currentSearchText = searchText
        }
    }
}

// Extension for placeholder functionality
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

#Preview {
    MainView()
}


struct AllSearchContentView: View {
    let searchText: String
    @ObservedObject var searchVM: SearchViewModel
    
    var body: some View {
        //        VStack(spacing: 20) {
        //            // Показуємо всі типи результатів
        //            if !searchVM.tracks.isEmpty {
        //                SearchSectionView(title: "Songs", items: Array(searchVM.tracks.prefix(3))) { track in
        //                    TrackRowView(track: track)
        //                }
        //            }
        //
        //            if !searchVM.artists.isEmpty {
        //                SearchSectionView(title: "Artists", items: Array(searchVM.artists.prefix(3))) { artist in
        Text("all")
        //                    ArtistRowView(artist: artist)
        //                }
        //            }
        //
        //            if !searchVM.albums.isEmpty {
        //                SearchSectionView(title: "Albums", items: Array(searchVM.albums.prefix(3))) { album in
        //                    AlbumRowView(album: album)
        //                }
        //            }
        //
        //            if !searchVM.playlists.isEmpty {
        //                SearchSectionView(title: "Playlists", items: Array(searchVM.playlists.prefix(3))) { playlist in
        //                    PlaylistRowView(playlist: playlist)
        //                }
        //            }
        //        }
    }
}

struct SongsSearchContentView: View {
    let searchText: String
    @ObservedObject var searchVM: SearchViewModel
    
    var body: some View {
        TrackListViewImage(tracks: searchVM.tracks)
            .padding(.bottom, 100)
        LazyVStack(spacing: 12) {
            TrackListViewImage(tracks: searchVM.tracks)
        }
    }
}

struct AlbumsSearchContentView: View {
    let searchText: String
    @ObservedObject var searchVM: SearchViewModel
    
    var body: some View {
        LazyVStack(spacing: 12) {
            //            ForEach(searchVM.albums, id: \.id) { album in
            //                AlbumRowView(album: album)
            //            }
            
            if searchVM.albums.isEmpty {
                NoResultsView(type: "albums")
            }
        }
    }
}

struct ArtistsSearchContentView: View {
    let searchText: String
    @ObservedObject var searchVM: SearchViewModel
    
    var body: some View {
        LazyVStack(spacing: 12) {
            //            ForEach(searchVM.artists, id: \.id) { artist in
            //                ArtistRowView(artist: artist)
            //            }
            
            if searchVM.artists.isEmpty {
                NoResultsView(type: "artists")
            }
        }
    }
}

struct PlaylistsSearchContentView: View {
    let searchText: String
    @ObservedObject var searchVM: SearchViewModel
    
    var body: some View {
        LazyVStack(spacing: 12) {
            //            ForEach(searchVM.playlists, id: \.id) { playlist in
            //                PlaylistRowView(playlist: playlist)
            //            }
            
            if searchVM.playlists.isEmpty {
                NoResultsView(type: "playlists")
            }
        }
    }
}

struct ProfilesSearchContentView: View {
    let searchText: String
    @ObservedObject var searchVM: SearchViewModel
    
    var body: some View {
        LazyVStack(spacing: 12) {
            //            ForEach(searchVM.playlists, id: \.id) { playlist in
            //                PlaylistRowView(playlist: playlist)
            //            }
            
            if searchVM.playlists.isEmpty {
                NoResultsView(type: "playlists")
            }
        }
    }
}

// MARK: - Допоміжні View компоненти

struct SearchSectionView<Item, Content: View>: View {
    let title: String
    let items: [Item]
    let content: (Item) -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.customFont(.bold, fontSize: 18))
                    .foregroundColor(.primaryText)
                
                Spacer()
                
                Button("See all") {
                    
                }
                .font(.customFont(.medium, fontSize: 14))
                .foregroundColor(.green)
            }
            .padding(.horizontal, 20)
            
            LazyVStack(spacing: 8) {
                ForEach(items.indices, id: \.self) { index in
                    content(items[index])
                }
            }
        }
    }
}

struct EmptySearchView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.primaryText.opacity(0.3))
                .padding(.top, 60)
            
            Text("Start typing to search...")
                .foregroundColor(.primaryText.opacity(0.7))
                .font(.customFont(.regular, fontSize: 16))
            
            Text("Find your favorite songs, artists, albums and playlists")
                .foregroundColor(.primaryText.opacity(0.5))
                .font(.customFont(.regular, fontSize: 14))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

struct NoResultsView: View {
    let type: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.primaryText.opacity(0.3))
                .padding(.top, 40)
            
            Text("No \(type) found")
                .font(.customFont(.medium, fontSize: 16))
                .foregroundColor(.primaryText)
            
            Text("Try adjusting your search terms")
                .font(.customFont(.regular, fontSize: 14))
                .foregroundColor(.primaryText.opacity(0.7))
        }
    }
}
