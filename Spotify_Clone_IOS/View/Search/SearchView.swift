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
    @State private var currentSearchText: String = ""
    @State private var selectedTab: SearchTab = .all
    
    @StateObject private var searchVM = SearchViewModel()
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var playerManager: AudioPlayerManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingSearchResults = false
    @State private var hasInitialized = false
    @FocusState private var isSearchFieldFocused: Bool

    
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
        ZStack {
            Color.bg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Фіксований хедер з пошуком
                searchHeaderView
                    .background(Color.lightBg)
                    .zIndex(1)
                
                // Контент
                contentView
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            if !hasInitialized {
                currentSearchText = searchText
                hasInitialized = true
                
                if !searchText.isEmpty {
                    performSearch()
                }
            }
        }
        .onDisappear {
            mainVM.isTabBarVisible = false
        }
    }
    
    private var searchHeaderView: some View {
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
                        .focused($isSearchFieldFocused)
                        .foregroundColor(.white)
                        .font(.customFont(.regular, fontSize: 16))
                        .tint(.white)
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
                            isSearchFieldFocused = false
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
    }
    
    private var contentView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                if !availableTabs.isEmpty {
                    switch selectedTab {
                    case .all:
                        AllSearchContentView(selectedTab: $selectedTab, searchVM: searchVM)
                            .padding(.bottom, 100).environmentObject(mainVM)
                            .environmentObject(playerManager)
                    case .songs:
                        TrackListViewImage(tracks: searchVM.tracks)
                            .padding(.top, 20).environmentObject(mainVM)
                            .environmentObject(playerManager)
                    case .albums:
                        AlbumsSearchContentView(searchVM: searchVM).environmentObject(mainVM)
                            .environmentObject(playerManager)
                            .padding(.top, 20)
                    case .artists:
                        ArtistsSearchContentView(searchVM: searchVM).environmentObject(mainVM)
                            .environmentObject(playerManager)
                            .padding(.top, 20)
                    case .playlists:
                        PlaylistsSearchContentView(searchVM: searchVM)
                            .padding(.top, 20)
                            .environmentObject(mainVM)
                            .environmentObject(playerManager)
                    }
                } else {
                    EmptySearchView()
                }
            }
            .padding(.bottom, 120) // Додатковий відступ знизу
        }
        .onTapGesture {
            // Приховати клавіатуру
            isSearchFieldFocused = false
        }
        
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



enum SearchTab: String, CaseIterable {
    case all = "All"
    case songs = "Songs"
    case albums = "Albums"
    case artists = "Artists"
    case playlists = "Playlists"
    
}

