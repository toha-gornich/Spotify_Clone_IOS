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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(SearchTab.allCases, id: \.self) { tab in
                            Button(action: {
                                selectedTab = tab
                            }) {
                                Text(tab.rawValue)
                                    .font(.customFont(.medium, fontSize: 14))
                                    .foregroundColor(selectedTab == tab ? .black : .white)
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
            }
            .background(Color.lightBg)
            
            // Content area
            ScrollView(showsIndicators: false) {
                VStack {
                    if !currentSearchText.isEmpty {
                        Text("Search results for: \(currentSearchText)")
                            .foregroundColor(.primaryText)
                            .font(.customFont(.regular, fontSize: 16))
                            .padding(.top, 20)
                        
                        Text("Selected tab: \(selectedTab.rawValue)")
                            .foregroundColor(.primaryText.opacity(0.7))
                            .font(.customFont(.regular, fontSize: 14))
                            .padding(.top, 8)
                    } else {
                        Text("Start typing to search...")
                            .foregroundColor(.primaryText.opacity(0.7))
                            .font(.customFont(.regular, fontSize: 16))
                            .padding(.top, 40)
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
