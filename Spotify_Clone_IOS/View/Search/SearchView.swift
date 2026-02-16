//
//  SearchView.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 28.07.2025.
//

import SwiftUI
import Combine

struct SearchView: View {
    @State var searchText: String
    @State private var searchQuery = ""
    @State private var selectedTab: SearchTab = .all
    @StateObject private var searchDebouncer = SearchTextDebouncer()
    
    @StateObject private var searchVM = SearchViewModel()
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var playerManager: AudioPlayerManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingSearchResults = false
    @State private var hasInitialized = false
    @FocusState private var isSearchFieldFocused: Bool
    
    private var availableTabs: [SearchTab] {
        guard !searchQuery.isEmpty else { return [] }
        
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
                searchHeaderView
                    .background(Color.lightBg)
                    .zIndex(1)
                contentView
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            mainVM.isTabBarVisible = true
            if !hasInitialized {
                searchDebouncer.searchText = searchText
                hasInitialized = true
                
                if !searchText.isEmpty {
                    performSearch(with: searchText)
                }
            }
        }
        .onChange(of: searchDebouncer.debouncedSearchText) { newValue in
            if !newValue.isEmpty && newValue != searchQuery {
                print("🔍 Debounced search triggered for: '\(newValue)'")
                performSearch(with: newValue)
            }
        }
    }
    
    private var searchHeaderView: some View {
        VStack(spacing: 0) {
            // Search field section
            HStack(spacing: 12) {
                // Search field with magnifying glass
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.system(size: 18))

                    TextField("", text: $searchDebouncer.searchText)
                        .focused($isSearchFieldFocused)
                        .foregroundColor(.white)
                        .font(.customFont(.regular, fontSize: 16))
                        .tint(.white)
                        .placeholder(when: searchDebouncer.searchText.isEmpty) {
                            Text("What do you want to listen to?")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.customFont(.regular, fontSize: 16))
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        .onSubmit {
                            print("Press Enter")
                            let trimmed = searchDebouncer.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                            if !trimmed.isEmpty {
                                performSearch(with: trimmed)
                            }
                            isSearchFieldFocused = false
                        }
                    
                    // Clear button container
                    HStack {
                        if !searchDebouncer.searchText.isEmpty {
                            Button(action: {
                                searchDebouncer.searchText = ""
                                searchQuery = ""
                                // Очищаємо результати пошуку
                                searchVM.tracks = []
                                searchVM.artists = []
                                searchVM.albums = []
                                searchVM.playlists = []
                                searchVM.profiles = []
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
                            .padding(.bottom, 100)
                            .environmentObject(mainVM)
                            .environmentObject(playerManager)
                        
                    case .songs:
                        TrackListViewImage(
                            tracks: searchVM.tracks,
                            onLoadMore: {
                                searchVM.loadMoreTracks()
                            },
                            isLoading: searchVM.isLoadingMoreTracks
                        )
                        .padding(.top, 20)
                        .environmentObject(mainVM)
                        .environmentObject(playerManager)
                        
                    case .albums:
                        AlbumsSearchContentView(
                            searchVM: searchVM,
                            onLoadMore: {
                                searchVM.loadMoreAlbums()
                            },
                            isLoading: searchVM.isLoadingMoreAlbums
                        )
                        .environmentObject(mainVM)
                        .environmentObject(playerManager)
                        .padding(.top, 20)
                        
                    case .artists:
                        ArtistsSearchContentView(
                            searchVM: searchVM,
                            onLoadMore: {
                                searchVM.loadMoreArtists()
                            },
                            isLoading: searchVM.isLoadingMoreArtists
                        )
                        .environmentObject(mainVM)
                        .environmentObject(playerManager)
                        .padding(.top, 20)
                        
                    case .playlists:
                        PlaylistsSearchContentView(
                            searchVM: searchVM,
                            onLoadMore: {
                                searchVM.loadMorePlaylists()
                            },
                            isLoading: searchVM.isLoadingMorePlaylists
                        )
                        .padding(.top, 20)
                        .environmentObject(mainVM)
                        .environmentObject(playerManager)
                    }
                } else {
                    EmptySearchView()
                }
            }
            .padding(.bottom, 120)
        }
        .id(selectedTab)
        .onTapGesture {
            isSearchFieldFocused = false
        }
    }
    
    private func performSearch(with text: String) {
        guard !text.isEmpty else {
            print("⚠️ SearchView - Empty search text, skipping")
            return
        }
        
        guard text != searchQuery else {
            print("⚠️ SearchView - Same search query, skipping")
            return
        }
        
        searchQuery = text
        isShowingSearchResults = true
        
        print("🔍 SearchView - Performing search for: '\(searchQuery)'")
        
        searchVM.searchTracks(searchText: searchQuery)
        searchVM.searchArtists(searchText: searchQuery)
        searchVM.searchAlbums(searchText: searchQuery)
        searchVM.searchPlaylists(searchText: searchQuery)
        searchVM.searchProfiles(searchText: searchQuery)
    }
}

#Preview {
    MainView()
}


