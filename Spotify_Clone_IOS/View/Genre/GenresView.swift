//
//  SearchVIew.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 21.07.2025.
//

import SwiftUI

struct GenresView: View {
    
    @State private var searchText = ""
    @State private var searchQuery = ""
    @State private var isShowingSearchResults = false
    @StateObject private var genreVM = GenresViewModel()
    @EnvironmentObject var mainVM: MainViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack(spacing: 15) {
                        Button {
                            print("open Menu")
                            mainVM.isShowMenu = true
                        } label: {
                            Image("settings")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                        }
                        
                        Text("Search")
                            .font(.customFont(.bold, fontSize: 18))
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                        
                        if genreVM.isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                    .padding(.top, .topInsets)
                    .padding(.horizontal, 20)

                    // Search Field
                    HStack {
                        // Magnifying glass button
                        Button(action: {
                            performSearch()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.system(size: 18))
                        }
                        
                        TextField("What do you want to listen to?", text: $searchText)
                            .foregroundColor(.black)
                            .font(.customFont(.regular, fontSize: 16))
                            .onSubmit {
                                performSearch()
                            }
                        
                        // Clear button
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                // Скидаємо результати пошуку при очищенні
                                isShowingSearchResults = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 18))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20) 
                    .padding(.vertical, 6)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 10) {
                            ForEach(0..<genreVM.genres.count, id: \.self) { index in
                                NavigationLink(destination: GenreDetailsView(
                                            slugGenre: genreVM.genres[index].slug,
                                            genresVM: genreVM
                                        )) {
                                    if index == 0 {
                                        SearchCardView(genre: genreVM.genres[index])
                                            .gridCellColumns(2)
                                    } else {
                                        SearchCardView(genre: genreVM.genres[index])
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                    .task {
                        genreVM.getGenres()
                    }
                }
            }
            .frame(width: .screenWidth, height: .screenHeight)
            .background(Color.bg)
            .navigationTitle("")
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .navigationDestination(isPresented: $isShowingSearchResults) {
                SearchView(searchText: searchQuery)
            }
            .onAppear {
                mainVM.isTabBarVisible = true
                print("Genres " + String(mainVM.isTabBarVisible))
            }
//            .onDisappear {
//                mainVM.isTabBarVisible = false
//                print("Genres " + String(mainVM.isTabBarVisible))
//            }
        }
        .alert(item: $genreVM.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
    
    private func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        searchQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isShowingSearchResults = true
            print("Search: \(searchQuery)")
        }
    }
}
