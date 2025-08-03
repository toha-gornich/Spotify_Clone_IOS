//
//  SearchView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 28.07.2025.
//

import SwiftUI
struct SearchView: View {
    @State var searchText: String
    @State private var searchQuery = ""
    @State private var searchTimer: Timer?
    @StateObject private var searchVM = SearchViewModel()
    @State private var currentSearchText: String = ""
    @State private var selectedTab: SearchTab = .all
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingSearchResults = false
    @State private var hasInitialized = false

    
    private var availableTabs: [SearchTab] {
        guard !currentSearchText.isEmpty else { return [] }
        
        var tabs: [SearchTab] = []
        
        //Check if there are results for each type
        let hasSongs = !searchVM.tracks.isEmpty
        let hasAlbums = !searchVM.albums.isEmpty
        let hasArtists = !searchVM.artists.isEmpty
        let hasPlaylists = !searchVM.playlists.isEmpty
        

        if hasSongs || hasAlbums || hasArtists || hasPlaylists {
            tabs.append(.all)
        }
        
        
        if hasSongs { tabs.append(.songs) }
        if hasAlbums { tabs.append(.albums) }
        if hasArtists { tabs.append(.artists) }
        if hasPlaylists { tabs.append(.playlists) }
        
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
                        Button(action: {
                            performSearch()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 18))
                        }

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
                            .onSubmit {
                                print("Press Enter")
                                searchTimer?.invalidate()
                                performSearch()
                            }
                            .onChange(of: currentSearchText) { newValue in
                                searchTimer?.invalidate()
                                
                                
                                if !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                                        performSearch()
                                    }
                                }
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
                            AllSearchContentView(selectedTab: $selectedTab, searchVM: searchVM)
                                .padding(.bottom, 100)
                        case .songs:
                            TrackListViewImage(tracks: searchVM.tracks)
                                .padding(.top, 20)
                        case .albums:
                            AlbumsSearchContentView(searchVM: searchVM)
                                .padding(.top, 20)
                        case .artists:
                            ArtistsSearchContentView(searchVM: searchVM)
                                .padding(.top, 20)
                        case .playlists:
                            PlaylistsSearchContentView(searchVM: searchVM)
                                .padding(.top, 20)
                        }
                    } else {
                        EmptySearchView()
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onAppear {
                
                if !hasInitialized {
                    currentSearchText = searchText
                    hasInitialized = true
                    
                    if !searchText.isEmpty {
                        performSearch()
                    }
                }

            }
            .background(Color.bg)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.container, edges: .top)
        
    }
    
    private func performSearch() {
        guard !currentSearchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        searchQuery = currentSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isShowingSearchResults = true
            print("Search: \(searchQuery)")
            
            
            searchVM.searchTracks(searchText: currentSearchText)
            searchVM.searchArtists(searchText: currentSearchText)
            searchVM.searchAlbums(searchText: currentSearchText)
            searchVM.searchPlaylists(searchText: currentSearchText)
            searchVM.searchProfiles(searchText: currentSearchText)
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
    @Binding var selectedTab: SearchTab
    @ObservedObject var searchVM: SearchViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 20) {
                if !searchVM.tracks.isEmpty {
                    
                    ViewAllSection(title: "Top result",buttonFlag: false)
                    
                    TopResultView(track: searchVM.tracks[0])
                    
                    ViewAllSection(title: "Songs",buttonFlag: false )
                        .onTapGesture {selectedTab = SearchTab.songs}
                    
                    TrackListViewImage(tracks: searchVM.tracks, maxItems6: true, padding: 8)
                }
                
                if !searchVM.artists.isEmpty {
                    ViewAllSection(title: "Artists",buttonFlag: false )
                        .padding(.horizontal)
                        .onTapGesture {selectedTab = SearchTab.artists}
                    ArtistsSearchContentView(searchVM: searchVM, maxItems6: true, padding: 8)
                }
                
                if !searchVM.albums.isEmpty {
                    ViewAllSection(title: "Albums",buttonFlag: false )
                        .padding(.horizontal)
                        .onTapGesture {selectedTab = SearchTab.albums}
                    
                    AlbumsSearchContentView(searchVM: searchVM, maxItems6: true, padding: 8 )
                }
                
                if !searchVM.playlists.isEmpty {
                    ViewAllSection(title: "Playlists",buttonFlag: false )
                        .padding(.horizontal)
                        .onTapGesture {selectedTab = SearchTab.playlists}
                    PlaylistsSearchContentView(searchVM: searchVM, maxItems6: true,  padding: 8)
                }
                if !searchVM.profiles.isEmpty {
                    ViewAllSection(title: "Profiles",buttonFlag: false )
                        .padding(.horizontal)
                }
            }
        }
        .padding(.bottom, 100)
        .padding(.horizontal)
    }
}


struct AlbumsSearchContentView: View {
    @ObservedObject var searchVM: SearchViewModel
    let maxItems6: Bool
    let padding: Int
    
    private var limitedItems: [Album] {
        if maxItems6{
            Array(searchVM.albums.prefix(6))
        }else {
            Array(searchVM.albums)
        }
        
    }
    
    init(searchVM: SearchViewModel, maxItems6: Bool = false, padding: Int = 70) {
        self.searchVM = searchVM
        self.maxItems6 = maxItems6
        self.padding = padding
    }
    
    var body: some View {
        ScrollView(showsIndicators: false){
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(0..<limitedItems.count, id: \.self) { index in
                    let sObj = searchVM.albums[index]
                    NavigationLink(destination: AlbumView(slugAlbum: sObj.slug)) {
                        MediaItemCell(imageURL: sObj.image, title: sObj.title, width: 140, height: 140)
                    }
                }
                
            }
            .padding(.bottom, CGFloat(padding))
        }
    }
}

struct ArtistsSearchContentView: View {
    @ObservedObject var searchVM: SearchViewModel
    let maxItems6: Bool
    let padding: Int
    
    private var limitedItems: [Artist] {
        if maxItems6{
            Array(searchVM.artists.prefix(6))
        }else {
            Array(searchVM.artists)
        }
        
    }
    
    init(searchVM: SearchViewModel, maxItems6: Bool = false, padding: Int = 70) {
        self.searchVM = searchVM
        self.maxItems6 = maxItems6
        self.padding = padding
    }
    
    var body: some View {
        ScrollView(showsIndicators: false){
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(0..<limitedItems.count, id: \.self) { index in
                    let sObj = searchVM.artists[index]
                    NavigationLink(destination: ArtistView(slugArtist: sObj.slug)) {
                        ArtistItemView(artist: sObj)
                    }
                }
                
            }
            .padding(.bottom, CGFloat(padding))

        }
    }
}

struct PlaylistsSearchContentView: View {
    @ObservedObject var searchVM: SearchViewModel
    let maxItems6: Bool
    let padding: Int
    
    private var limitedItems: [Playlist] {
        if maxItems6{
            Array(searchVM.playlists.prefix(6))
        }else {
            Array(searchVM.playlists)
        }
        
    }
    
    init(searchVM: SearchViewModel, maxItems6: Bool = false, padding: Int = 70) {
        self.searchVM = searchVM
        self.maxItems6 = maxItems6
        self.padding = padding
    }
    
    var body: some View {
        ScrollView(showsIndicators: false){
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(0..<limitedItems.count, id: \.self) { index in
                    let sObj = searchVM.playlists[index]
                    NavigationLink(destination: PlaylistView(slugPlaylist: sObj.slug)) {
                        MediaItemCell(imageURL: sObj.image, title: sObj.title, width: 140, height: 140)
                    }
                }
                
            }
            .padding(.bottom, CGFloat(padding))
//            .padding(.top, 20)
        }
    }
}

struct ProfilesSearchContentView: View {
    //    let searchText: String
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


enum SearchTab: String, CaseIterable {
    case all = "All"
    case songs = "Songs"
    case albums = "Albums"
    case artists = "Artists"
    case playlists = "Playlists"
    
}

struct TopResultView: View {
    let track: Track
    var body: some View {
        NavigationLink(destination: TrackView(slugTrack: track.slug)){
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: track.album.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(8)
                
                // Song info
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.customFont(.bold, fontSize: 16))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Text("Song")
                            .font(.customFont(.regular, fontSize: 14))
                            .foregroundColor(.gray)
                        
                        Text("•")
                            .font(.customFont(.regular, fontSize: 14))
                            .foregroundColor(.gray)
                        
                        Text(track.artist.displayName)
                            .font(.customFont(.regular, fontSize: 14))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Play button
                Button(action: {
                    // Play action
                    print("Play")
                }) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "play.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                                .offset(x: 1) // Slight offset for visual balance
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.lightBg)
            .cornerRadius(8)
        }
    }
}
